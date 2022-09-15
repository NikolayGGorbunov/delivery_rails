# frozen_string_literal: true

module Packages
  class Update < ActiveInteraction::Base
    object :user, class: User, default: nil
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
      package.width = width
      package.length = length
      package.height = height
      package.weight = weight
      package.start_point = start_point
      package.end_point = end_point
      if package_values_changed?
        package.distance, package.price = calculate_price.values
      end
      change_state

      if inputs.given?(:user)
        package.first_name = user.first_name
        package.second_name = user.second_name
        package.third_name = user.third_name
        package.email = user.email
        package.phone = user.phone
      end

      errors.merge!(package.errors) unless package.save

      package
    end

    private

    def package_values_changed?
      package.width_changed? || package.length_changed? || package.height_changed? ||
        package.weight_changed? || package.start_point_changed? || package.end_point_changed?
    end

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
