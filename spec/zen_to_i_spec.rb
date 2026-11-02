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

    it "半角数字と漢数字単位が混ざる場合も正しく変換する" do
      expect("3万".zen_to_i).to eq "30000"
      expect("12万".zen_to_i).to eq "120000"
      expect("3万5千".zen_to_i).to eq "35000"
      expect("1億2万".zen_to_i).to eq "100020000"
      expect("3百".zen_to_i).to eq "300"
    end

    it "位のあとに複数桁の半角数字が続いても分割しない" do
      expect("3千500円".zen_to_i).to eq "3500円"
      expect("1万2千345".zen_to_i).to eq "12345"
      expect("1千2百34".zen_to_i).to eq "1234"
      expect("百34".zen_to_i).to eq "134"
      expect("1000万".zen_to_i).to eq "10000000"
    end

    it "全角数字と漢数字単位が混ざる場合も正しく変換する" do
      expect("３万".zen_to_i).to eq "30000"
      expect("１２３万".zen_to_i).to eq "1230000"
      expect("３万５千".zen_to_i).to eq "35000"
      expect("１億２万".zen_to_i).to eq "100020000"
      expect("１０００万".zen_to_i).to eq "10000000"
      expect("３千５００円".zen_to_i).to eq "3500円"
    end

    it "半角数字だけの文字列は数値として評価せずそのまま返す" do
      expect("007".zen_to_i).to eq "007"
      expect("090".zen_to_i).to eq "090"
    end

    it "半角数字と漢数字が隣接する場合は個別の数字として扱う" do
      expect("第3四半期".zen_to_i).to eq "第34半期"
      expect("第1四半期".zen_to_i).to eq "第14半期"
      expect("一3".zen_to_i).to eq "13"
      expect("3三".zen_to_i).to eq "33"
      expect("3〇".zen_to_i).to eq "30"
    end

    it "桁区切りや小数点を含む場合は非対応として現状の結果を返す" do
      expect("1,000万".zen_to_i).to eq "1,0"
      expect("3.5万".zen_to_i).to eq "3.50000"
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

    it "位が小さい順に並ぶ場合は別の数として連結する" do
      expect("十十".zen_to_i).to eq "1010"
      expect("百百".zen_to_i).to eq "100100"
      expect("十百".zen_to_i).to eq "10100"
      expect("百千".zen_to_i).to eq "1001000"
      expect("百三百".zen_to_i).to eq "100300"
      expect("十二十".zen_to_i).to eq "1020"
    end

    it "位が大きい順に並ぶ場合は同じ数の桁として扱う" do
      expect("百十".zen_to_i).to eq "110"
      expect("千百".zen_to_i).to eq "1100"
      expect("千二百三十四".zen_to_i).to eq "1234"
    end

    it "連結した数のあとに加算が続いても壊れない" do
      expect("百十十".zen_to_i).to eq "11010"
      expect("十百十".zen_to_i).to eq "10110"
      expect("十百三".zen_to_i).to eq "10103"
      expect("十十三".zen_to_i).to eq "1013"
    end

    it "万・億・兆の重複はセクションの加算として扱う" do
      expect("一億一億".zen_to_i).to eq "200000000"
      expect("兆兆".zen_to_i).to eq "2000000000000"
      expect("十十万".zen_to_i).to eq "10100000"
    end

    it "位のあとの数字は1桁だけ同じ数に入り、2桁目以降は別の数として連結する" do
      expect("百二三十".zen_to_i).to eq "10230"
      expect("百二三四".zen_to_i).to eq "10234"
      expect("十二三".zen_to_i).to eq "123"
      expect("百八九".zen_to_i).to eq "1089"
      expect("百三".zen_to_i).to eq "103"
    end

    it "位記号を含まない漢数字だけの並びは先頭ゼロを保持してそのまま連結する" do
      expect("〇〇七".zen_to_i).to eq "007"
      expect("〇〇一号".zen_to_i).to eq "001号"
      expect("〇三-1234-5678".zen_to_i).to eq "03-1234-5678"
    end
  end
end
