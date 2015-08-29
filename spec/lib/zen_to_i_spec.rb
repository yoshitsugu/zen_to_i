# coding: utf-8
require File.dirname(__FILE__)+"/../spec_helper"

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
      
  end
end
