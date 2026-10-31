# frozen_string_literal: true

module ZenToI
  module Constant
    unless const_defined?(:KANNUM, false)
      KANNUM = { "〇" => 0, "" => 1, "一" => 1, "二" => 2, "三" => 3, "四" => 4,
                 "五" => 5, "六" => 6, "七" => 7, "八" => 8, "九" => 9,
                 "零" => 0, "壱" => 1, "弐" => 2, "参" => 3, "肆" => 4,
                 "伍" => 5, "陸" => 6, "漆" => 7, "捌" => 8, "玖" => 9 }.freeze
      KANORDER = { "十" => 10, "百" => 100, "千" => 1000, "" => 1, "拾" => 10,
                   "陌" => 100, "佰" => 100, "阡" => 1000, "仟" => 1000 }.freeze
      KANORDER_F = { "万" => 10**4, "億" => 10**8, "兆" => 10**12,
                     "" => 1, "萬" => 10**4 }.freeze
      ALL_KANSUUJI = KANNUM.keys + KANORDER.keys + KANORDER_F.keys
      ASCII_DIGITS = (0..9).map(&:to_s)
      MAX_LOOP = 100
      KANORDER_F_KEYS_REGEX = /([^#{KANORDER_F.keys.join("")}]*)([#{KANORDER_F.keys.join("")}]?)/
      KANORDER_KEYS_REGEX = /([^#{KANORDER.keys.join("")}]*)([#{KANORDER.keys.join("")}]?)/
      # 半角数字が漢数字ブロックに混ざる場合（例: 3万）も漢数字側として扱う
      ALL_KANSUUJI_REGEX = /([#{ALL_KANSUUJI.join("")}#{ASCII_DIGITS.join("")}]+)/
      # 半角数字だけのブロック（例: 007）は数値として評価せず素通しする
      ASCII_DIGITS_ONLY_REGEX = /\A[0-9]+\z/
      KANNUM_PAIR_REGEX = /([#{KANNUM.keys.join("")}])([#{KANNUM.keys.join("")}])/
      # 半角数字と漢数字の境界は位ではなく個別の数字なので分割する（例: 3四 -> 3,四）
      ASCII_KANNUM_PAIR_REGEXES = [
        /([0-9])([#{KANNUM.keys.join("")}])/,
        /([#{KANNUM.keys.join("")}])([0-9])/
      ].freeze
    end
  end

  Constant.freeze
end
