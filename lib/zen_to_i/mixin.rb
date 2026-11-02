# frozen_string_literal: true

require_relative "constant"
require_relative "parser"

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

      # 漢数字ブロックだけを数値化する。半角数字だけのブロック（007 など）は素通しする。
      def convert_kansuuji(array)
        array.map do |a|
          kansuuji_block?(a) ? ::ZenToI::Parser.call(a) : a
        end
      end

      def kansuuji_block?(str)
        !ASCII_DIGITS_ONLY_REGEX.match?(str) && ALL_KANSUUJI_REGEX.match?(str)
      end
  end
end
