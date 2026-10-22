# frozen_string_literal: true

require_relative "../zen_to_i"
require_relative "to_i"

class String
  unless String.instance_methods(false).include?(:_to_i)
    alias_method :_to_i, :to_i
  end

  define_method(:to_i, ZenToI::ToI.instance_method(:to_i))
end
