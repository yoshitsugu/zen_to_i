# frozen_string_literal: true

require_relative "./constant"

module ZenToI
  module Mixin
    include ::ZenToI::Constant

    def zen_to_i
      result = kanji2num(self)
      zen2han(result)
    end

    private

      def kanji2num(str)
        array = split_kansuuji(str)
        array = split_kansuuji_detail(array)
        result = convert_kansuuji(array)
        result.join("")
      end

      def zen2han(str)
        str.tr("０-９", "0-9")
      end

      # 漢数字のところだけ切り出す
      def split_kansuuji(string)
        string.split(/([#{ALL_KANSUUJI.join('')}]+)/)
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
          if /([#{ALL_KANSUUJI.join('')}]+)/.match?(a)
            kannum = KANNUM.keys.join("")
            a.gsub(/([#{kannum}])([#{kannum}])/, '\1,\2').split(",")
          else
            a
          end
        end
        ary.flatten
      end

      # ４桁ごとの単位（万、億、兆など）でまずわけ、
      # それぞれに対して漢数字→数字を実行している。
      def convert_kansuuji(array)
        array.map do |a|
          if /([#{ALL_KANSUUJI.join('')}]+)/.match?(a)
            a.scan(KANORDER_F_KEYS_REGEX).inject(0) do |ret, (unit, order_f)|
              unit_i = unit.scan(KANORDER_KEYS_REGEX).inject(-1) do |tmp, (kanji, order)|
                tmp + KANNUM[kanji].to_i * KANORDER[order].to_i
              end
              ret + unit_i * KANORDER_F[order_f].to_i
            end
          else
            a
          end
        end
      end

      def format_location(string)
        location_map.each do |key, value|
          string.gsub!(/#{key}/, value)
        end
        string
      end
  end
end
