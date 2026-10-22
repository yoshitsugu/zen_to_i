# frozen_string_literal: true

require "zen_to_i"

describe ZenToI::Constant do
  describe "複数回読み込んでも例外にならない" do
    it "constantを再度読み込んでも定数が残る" do
      expect { load File.expand_path("../lib/zen_to_i/constant.rb", __dir__) }.not_to raise_error

      expect(ZenToI::Constant::KANNUM["一"]).to eq 1
      expect("一二三".zen_to_i).to eq "123"
    end

    it "定数定義がスキップされModuleがfrozenのまま維持される" do
      load File.expand_path("../lib/zen_to_i/constant.rb", __dir__)

      expect(ZenToI::Constant).to be_frozen
    end
  end
end
