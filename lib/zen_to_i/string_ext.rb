# frozen_string_literal: true

require_relative "../zen_to_i"
require_relative "to_i"

# 読み込むと String#to_i が漢数字変換に差し替わる。元の実装は String#_to_i に残る。
class String
  alias _to_i to_i unless String.method_defined?(:_to_i, false)

  define_method(:to_i, ZenToI::ToI.instance_method(:to_i))
end
