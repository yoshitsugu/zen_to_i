# coding: utf-8
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zen_to_i/version'
require 'zen_to_i/constant'

class String
  module Zen2Num
    def zen_to_i
      result = kanji2num(self)
      zen2han(result)
    end

    def kanji2num(string)
      array = split_kansuuji(string)
      array = split_kansuuji_detail(array)
      result = convert_kansuuji(array)
      result.join('')
    end
    
    def zen2han str
      str.tr("０-９","0-9")
    end
    
    private
    
    #漢数字のところだけ切り出す
    def split_kansuuji(string)
      string.split(/([#{ALL_KANSUUJI.join('')}]+)/)
    end
    
    #位を表す数ではない普通の漢数字が続いていたらわける
    def split_kansuuji_detail(array)
      array_tmp = array.clone
      array_result = array.clone
      (1..MAX_LOOP).each{|i|
        array_result = split_kansuuji_detail_inner(array_result)
        if array_result == array_tmp
          return array_result
        else
          array_tmp = array_result.clone
        end
      }
      array_result
    end
    
    def split_kansuuji_detail_inner(array)
      array.map{|a|
        if( a =~ /([#{ALL_KANSUUJI.join('')}]+)/)
          kannum = KANNUM.keys.join('')
          a.gsub(/([#{kannum}])([#{kannum}])/,'\1,\2').split(",")
        else
          a
        end
      }.flatten
    end

    # ４桁ごとの単位（万、億、兆など）でまずわけ、
    # それぞれに対して漢数字→数字を実行している。
    def convert_kansuuji(array)
      array.map{|a|
        if( a =~ /([#{ALL_KANSUUJI.join('')}]+)/)
          reg_order_f = /([^#{KANORDER_F.keys.join('')}]*)([#{KANORDER_F.keys.join('')}]?)/
          a.scan( reg_order_f ).inject(0) do |ret, (lt_1000, order_f)|
            reg_order = /([^#{KANORDER.keys.join('')}]*)([#{KANORDER.keys.join('')}]?)/
            lt_1000_i = lt_1000.scan( reg_order ).inject(-1) do |tmp, (_1_9, order)|
              tmp + KANNUM[_1_9].to_i * KANORDER[order].to_i
            end
            ret + lt_1000_i * KANORDER_F[order_f].to_i
          end          
        else
          a
        end
      }
    end
    
    
    def format_location string
      location_map.each{|key,value|
        string.gsub!(/#{key}/,value)
      }
      string
    end
    
  end
  include Zen2Num
end
