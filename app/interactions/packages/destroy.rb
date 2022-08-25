# frozen_string_literal: true

module Packages
  class Destroy < ActiveInteraction::Base
    object :package, class: Package

    def execute
      package.destroy
    end
  end
end
