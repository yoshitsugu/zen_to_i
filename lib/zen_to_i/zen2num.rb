# coding: utf-8
module Zen2Num
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

  #おおまかに漢数字のところだけ切り出す
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

  def convert_kansuuji(array)
    array.map{|a|
      if( a =~ /([#{ALL_KANSUUJI.join('')}]+)/)
        a.scan(/([^#{KANORDER_F.keys.join('')}]*)([#{KANORDER_F.keys.join('')}]?)/).inject(-1) do |ret, (lt_1000, order_f)|
          
          lt_1000_i = lt_1000.scan(/([^#{KANORDER.keys.join('')}]*)([#{KANORDER.keys.join('')}]?)/).inject(-1) do |tmp, (_1_9, order)|
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
