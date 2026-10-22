# frozen_string_literal: true

require_relative "../zen_to_i"

class String
  unless String.instance_methods(false).include?(:_to_i)
    alias_method :_to_i, :to_i
  end

  def to_i
    self.zen_to_i._to_i
  end
end
