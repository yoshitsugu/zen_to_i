# frozen_string_literal: true

require "zen_to_i/refine"

using ZenToI::Refine

describe ZenToI::Refine do
  describe "String#to_i refined" do
    it "usingを使っていると漢数字は変換できる" do
      expect("一二三".to_i).to eq 123
    end
  end

  describe "複数回読み込んでも無限再帰にならない" do
    it "refineを再度読み込んでもto_iが動作する" do
      load File.expand_path("../lib/zen_to_i/refine.rb", __dir__)

      expect { "一二三".to_i }.not_to raise_error
      expect("一二三".to_i).to eq 123
      expect("四五六".to_i).to eq 456
    end
  end
end
