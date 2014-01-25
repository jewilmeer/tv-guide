require 'active_support/concern'

module Concerns
  module Sections
    extend ActiveSupport::Concern

    included do
      def self.section(nr=0, items=30)
        limit(30).offset(items * (nr.to_i || 0))
      end
    end
  end
end