# frozen_string_literal: true

require_relative "../zen_to_i"
require_relative "to_i"

module ZenToI
  unless const_defined?(:Refine, false)
    module Refine
      refine String do
        define_method(:_to_i, ZenToI::ToI.instance_method(:_to_i))
        define_method(:to_i, ZenToI::ToI.instance_method(:to_i))
      end
    end
  end
end
