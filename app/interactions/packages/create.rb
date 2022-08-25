# frozen_string_literal: true

module Packages
  class Create < ActiveInteraction::Base
    object :user, class: User
    integer :width, :length, :height
    float   :weight
    string  :start_point, :end_point

    validates :weight, :width, :length, :height,
              comparison: { greater_than: 0 }
    validates :width, :length, :height,
              numericality: { only_integer: true }
    validates :weight, numericality: true
    validates :start_point, :end_point,
              absence: false

    def to_model
      Package.new
    end

    def execute
      package = user.packages.new(package_params)

      errors.merge!(package.errors) unless package.save

      package
    end

    private

    def calculate_price
      Delivery::Deliveryboy.give_package(inputs.except(:user)).slice(:distance, :price)
    end

    def package_params
      inputs.except(:user).merge({ first_name: user.first_name, second_name: user.second_name,
                                   third_name: user.third_name, email: user.email,
                                   phone: user.phone, **calculate_price })
    end
  end
end
