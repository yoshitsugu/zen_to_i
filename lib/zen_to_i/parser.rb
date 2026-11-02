# frozen_string_literal: true

require_relative "constant"

module ZenToI
  # 漢数字ブロック（例: "三兆五十二万四十八"）を整数に変換する。
  module Parser
    include ::ZenToI::Constant

    module_function

    # 位記号（十百千万億兆）を含まない数字だけのブロックは、先頭ゼロを保持するため
    # 数値化せず各桁をそのまま連結する（例: 〇〇七 => "007"）。
    def call(str)
      return digit_string(str) unless order_marker?(str)

      chunks = tokenize(str).slice_after { |kind, _| kind == :order_f }
      chunks.sum do |chunk|
        body, multiplier = split_chunk(chunk)
        section_value(body, multiplier)
      end.to_s
    end

    def digit_string(str)
      tokenize(str).map { |_kind, value| value.to_s }.join
    end

    # 万・億・兆で終わるまとまりは、その単位を乗数として切り離す。
    def split_chunk(chunk)
      last = chunk.last
      return [chunk, 1] unless last.first == :order_f

      [chunk[0..-2], last.last]
    end

    # 単位単体（万など）は 1 個分として数える。
    # セクション内は「位のあとの数字2桁目以降で分割」してから各チャンクを評価し連結する。
    def section_value(tokens, multiplier)
      return multiplier if tokens.empty?

      split_after_order_tail(tokens).map { |chunk| eval_section(chunk) }.join.to_i * multiplier
    end

    # 位記号（十百千）または大単位（万億兆）を含むか。
    def order_marker?(str)
      str.each_char.any? { |char| KANORDER.key?(char) || KANORDER_F.key?(char) }
    end

    # 半角数字の連続は1つの数として扱う（例: 3千500 の "500"）。
    def tokenize(str)
      str.scan(/[0-9]+|./).filter_map do |char|
        kind, value = token_of(char)
        [kind, value] if kind
      end
    end

    def token_of(char)
      if KANNUM.key?(char)
        [:num, KANNUM[char]]
      elsif ASCII_DIGITS_ONLY_REGEX.match?(char)
        [:num, char.to_i]
      elsif KANORDER.key?(char)
        [:order, KANORDER[char]]
      elsif KANORDER_F.key?(char)
        [:order_f, KANORDER_F[char]]
      end
    end

    # 位のあとに続く数字は1桁だけ同じ数に入れ、2桁目以降は別の数として分割する。
    # （例: 百二三十 => 百二 | 三十 => "102" + "30" = "10230"）
    def split_after_order_tail(tokens)
      seen_order = false
      tokens.slice_when do |before, after|
        cut = seen_order && before.first == :num && after.first == :num
        seen_order ||= before.first == :order
        cut
      end
    end

    # 位が小さくなる間は同じ数の桁として加算し、同じ位か大きい位が来たら別の数として連結する。
    def eval_section(tokens)
      state = { completed: [], current: 0, last_order: nil, pending: nil }
      tokens.each { |token| apply_token(state, token) }
      finish_section(state)
    end

    def apply_token(state, (kind, value))
      case kind
      when :num
        apply_num(state, value)
      when :order
        apply_order(state, value)
      end
    end

    def apply_num(state, value)
      state[:pending] = state[:pending].nil? ? value : (state[:pending] * 10) + value
    end

    def apply_order(state, value)
      coefficient = state[:pending].nil? ? 1 : state[:pending]
      if state[:last_order].nil? || value < state[:last_order]
        state[:current] += coefficient * value
      else
        state[:completed] << state[:current]
        state[:current] = coefficient * value
      end
      state[:last_order] = value
      state[:pending] = nil
    end

    def finish_section(state)
      state[:current] += state[:pending] unless state[:pending].nil?
      state[:completed] << state[:current]
      state[:completed].join.to_i
    end
  end
end
