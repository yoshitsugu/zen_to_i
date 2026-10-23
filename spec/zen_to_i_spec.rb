# frozen_string_literal: true

require "zen_to_i"

describe ZenToI do
  describe "String#zen_to_i" do
    it "数字以外の文字の場合はそのまま返す" do
      expect("hoge".zen_to_i).to eq "hoge"
    end

    it "漢数字の場合は半角数字に変換する" do
      expect("一二三".zen_to_i).to eq "123"
    end

    it "位をあらわす漢数字を含む場合も半角数字に変換する" do
      expect("百三".zen_to_i).to eq "103"
    end

    it "兆の位まで半角数字に変換する" do
      expect("三兆五十二万四十八".zen_to_i).to eq "3000000520048"
    end

    it "大字でも変換可能" do
      expect("肆佰参拾捌".zen_to_i).to eq "438"
    end

    it "単位単体はそのままの数量に変換する" do
      expect("万".zen_to_i).to eq "10000"
      expect("萬".zen_to_i).to eq "10000"
      expect("億".zen_to_i).to eq "100000000"
      expect("兆".zen_to_i).to eq "1000000000000"
    end

    it "位記号の重複や並びの不整合は例外にならず値を返す（値は保証されない）" do
      expect("十十".zen_to_i).to eq "20"
      expect("百百".zen_to_i).to eq "200"
      expect("十百".zen_to_i).to eq "110"
      expect("一億一億".zen_to_i).to eq "200000000"
      expect("兆兆".zen_to_i).to eq "2000000000000"
    end
  end
end
