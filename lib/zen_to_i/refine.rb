# frozen_string_literal: true

require_relative "../zen_to_i"

module ZenToI::Refine
  refine String do
    alias_method :_to_i, :to_i

    def to_i
      self.zen_to_i._to_i
    end
  end
end
