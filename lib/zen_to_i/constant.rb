class String
  module Zen2Num
    KANNUM = { '〇' => 0, '' => 1,'一' => 1, '二' => 2,'三' => 3, '四' => 4,
      '五' => 5, '六' => 6, '七' => 7, '八' => 8, '九' => 9 }
    KANORDER = {'十' => 10,'百' => 100, '千' => 1000 , '' => 1}
    KANORDER_F = { '万' => 10**4 , '億' => 10**8, '兆' => 10**12 , ''=> 1}
    ALL_KANSUUJI = KANNUM.keys + KANORDER.keys + KANORDER_F.keys
    MAX_LOOP = 100
  end
end
