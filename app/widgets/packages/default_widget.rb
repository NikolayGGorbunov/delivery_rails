# frozen_string_literal: true

module Packages
  class DefaultWidget
    attr_accessor :relation

    def initialize(org_id, group_by = nil)
      @relation = Package.of_org_by(org_id, group_by)
    end

    def self.call(*)
      raise(RuntimeError, "Can't call default widgets. Use descendant call")
    end
  end
end
