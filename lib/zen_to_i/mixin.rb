# frozen_string_literal: true

require_relative "constant"

module ZenToI
  module Mixin
    include ::ZenToI::Constant

    def zen_to_i
      result = kanji2num(self)
      zen2han(result)
    end

    private

      def kanji2num(str)
        array = split_kansuuji(zen2han(str))
        array = split_kansuuji_detail(array)
        result = convert_kansuuji(array)
        result.join("")
      end

      def zen2han(str)
        str.tr("０-９", "0-9")
      end

      # 漢数字のところだけ切り出す
      def split_kansuuji(string)
        string.split(ALL_KANSUUJI_REGEX)
      end

      # 位を表す数ではない普通の漢数字が続いていたらわける
      def split_kansuuji_detail(array)
        array_tmp = array.clone
        array_result = array.clone
        (1..MAX_LOOP).each do |_i|
          array_result = split_kansuuji_detail_inner(array_result)
          return array_result if array_result == array_tmp

          array_tmp = array_result.clone
        end
        array_result
      end

      def split_kansuuji_detail_inner(array)
        ary = array.map do |a|
          if kansuuji_block?(a)
            split_num_pairs(a)
          else
            a
          end
        end
        ary.flatten
      end

      # KANNUM 同士、および半角数字と KANNUM の境界をカンマで分割する。
      # 位記号（十百千など）との境界は分割しない。
      def split_num_pairs(str)
        result = str.gsub(KANNUM_PAIR_REGEX, '\1,\2')
        ASCII_KANNUM_PAIR_REGEXES.each { |regex| result = result.gsub(regex, '\1,\2') }
        result.split(",")
      end

      # ４桁ごとの単位（万、億、兆など）でまずわけ、
      # それぞれに対して漢数字→数字を実行している。
      # 半角数字だけのブロック（007 など）は数値として評価せず素通しする。
      def convert_kansuuji(array)
        array.map do |a|
          if kansuuji_block?(a)
            sum_kansuuji(a)
          else
            a
          end
        end
      end

      def kansuuji_block?(str)
        !ASCII_DIGITS_ONLY_REGEX.match?(str) && ALL_KANSUUJI_REGEX.match?(str)
      end

      def sum_kansuuji(str)
        str.scan(KANORDER_F_KEYS_REGEX).inject(0) do |ret, (unit, order_f)|
          ret + (unit_to_i(unit, order_f) * KANORDER_F[order_f].to_i)
        end
      end

      # 大字だけの表記は 1 個分として数え、scan の末尾の空一致は桁を持たないので 0 とする。
      def unit_to_i(unit, order_f)
        return order_f.empty? ? 0 : 1 if unit.empty?

        unit.scan(KANORDER_KEYS_REGEX).inject(-1) do |tmp, (kanji, order)|
          digit = KANNUM[kanji] || (kanji.to_i if ASCII_DIGITS_ONLY_REGEX.match?(kanji))
          tmp + (digit.to_i * KANORDER[order].to_i)
        end
      end
  end
end
