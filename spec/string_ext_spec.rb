# frozen_string_literal: true

require "zen_to_i/string_ext"

describe String do
  describe "#to_i overwritten" do
    it "to_iで漢数字変換ができる" do
      expect("一二三".to_i).to eq 123
    end
  end
end
