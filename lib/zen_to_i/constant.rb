# frozen_string_literal: true

module ZenToI
  module Constant
    KANNUM = { "〇" => 0, "" => 1, "一" => 1, "二" => 2, "三" => 3, "四" => 4,
               "五" => 5, "六" => 6, "七" => 7, "八" => 8, "九" => 9,
               "零" => 0, "壱" => 1, "弐" => 2, "参" => 3, "肆" => 4,
               "伍" => 5, "陸" => 6, "漆" => 7, "捌" => 8, "玖" => 9 }.freeze
    KANORDER = { "十" => 10, "百" => 100, "千" => 1000, "" => 1, "拾" => 10,
                 "陌" => 100, "佰" => 100, "阡" => 1000, "仟" => 1000 }.freeze
    KANORDER_F = { "万" => 10**4, "億" => 10**8, "兆" => 10**12,
                   "" => 1, "萬" => 10**4 }.freeze
    ALL_KANSUUJI = KANNUM.keys + KANORDER.keys + KANORDER_F.keys
    MAX_LOOP = 100
    KANORDER_F_KEYS_REGEX = /([^#{KANORDER_F.keys.join('')}]*)([#{KANORDER_F.keys.join('')}]?)/.freeze
    KANORDER_KEYS_REGEX = /([^#{KANORDER.keys.join('')}]*)([#{KANORDER.keys.join('')}]?)/.freeze
  end.freeze
end
