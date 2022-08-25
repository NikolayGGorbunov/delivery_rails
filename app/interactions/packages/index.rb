# frozen_string_literal: true

module Packages
  class Index < ActiveInteraction::Base
    object :user
    integer :page, default: 1
    string :direction, default: 'asc'
    string :sort, default: 'id'

    def execute
      if sort
        user.packages.order("#{sort_column} #{sort_direction}").page(page)
      else
        user.packages.page(page)
      end
    end

    private

    def sort_column
      Package.column_names.include?(sort) ? sort : 'id'
    end

    def sort_direction
      %w[asc desc].include?(direction) ?  direction : 'asc'
    end
  end
end
