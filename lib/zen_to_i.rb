require 'zen_to_i/requirements'

class String
  include Zen2Num
  def zen_to_i
    result = kanji2num(self)
    zen2han(result)
  end
end
