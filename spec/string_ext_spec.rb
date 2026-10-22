# frozen_string_literal: true

require "zen_to_i/string_ext"

describe String do
  describe "#to_i overwritten" do
    it "to_iで漢数字変換ができる" do
      expect("一二三".to_i).to eq 123
    end
  end

  describe "String#_to_i overwritten" do
    it "_to_iは差し替え前のto_iと同じ結果を返す" do
      expect("一二三"._to_i).to eq 0
      expect("123"._to_i).to eq 123
    end
  end

  describe "複数回読み込んでも無限再帰にならない" do
    it "string_extを再度読み込んでもto_iが動作する" do
      load File.expand_path("../lib/zen_to_i/string_ext.rb", __dir__)

      expect { "一二三".to_i }.not_to raise_error
      expect("一二三".to_i).to eq 123
      expect("四五六".to_i).to eq 456
    end
  end
end
