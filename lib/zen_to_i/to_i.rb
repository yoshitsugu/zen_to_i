# frozen_string_literal: true

require_relative "../zen_to_i"

module ZenToI
  # string_ext.rb（グローバルに適用）と refine.rb（refinement 経由）で共有する。
  module ToI
    # 差し替え前の String#to_i を保持する。読み込み時点で String 自身が持つ
    # ネイティブ実装を捕捉し、どのロード順でも素の to_i を参照できるようにする。
    ORIGINAL_TO_I = String.instance_method(:to_i) unless const_defined?(:ORIGINAL_TO_I, false)

    def to_i
      ORIGINAL_TO_I.bind(zen_to_i).call
    end

    def _to_i(*)
      ORIGINAL_TO_I.bind(self).call(*)
    end
  end
end
