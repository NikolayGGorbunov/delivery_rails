# frozen_string_literal: true

module Packages
  class Update < ActiveInteraction::Base
    object :package
    integer :width, :length, :height
    float   :weight
    string  :start_point, :end_point, :aasm_state

    validates :weight, :width, :length, :height,
              comparison: { greater_than: 0 }
    validates :width, :length, :height,
              numericality: { only_integer: true }
    validates :weight, numericality: true
    validates :start_point, :end_point, :aasm_state,
              absence: false

    def execute
      package.width = width if width.present?
      package.length = length if length.present?
      package.height = height if height.present?
      package.weight = weight if weight.present?
      package.start_point = start_point if start_point.present?
      package.end_point = end_point if end_point.present?
      package.distance, package.price = calculate_price.values
      change_state

      errors.merge!(package.errors) unless package.save

      package
    end

    private

    def calculate_price
      Delivery::Deliveryboy.give_package(inputs.except(:package)).slice(:distance, :price)
    end

    def change_state
      package.returning if package.may_returning? && aasm_state == 'returned'
      package.delivering if package.may_delivering? && aasm_state == 'delivery'
      package.ending if package.may_ending? && aasm_state == 'delivered'
    end
  end
end
