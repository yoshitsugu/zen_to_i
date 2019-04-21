# frozen_string_literal: true

require "zen_to_i/refine"

using ZenToI::Refine

describe ZenToI::Refine do
  describe "String#to_i refined" do
    it "usingを使っていると漢数字は変換できる" do
      expect("一二三".to_i).to eq 123
    end
  end
end
