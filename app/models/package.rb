# frozen_string_literal: true

class Package < ApplicationRecord
  validates :first_name, :second_name, :third_name, :phone,
            presence: true
  validates :weight, :width, :length, :height,
            comparison: { greater_than: 0 }
  validates :width, :length, :height,
            numericality: { only_integer: true }
  validates :weight, numericality: true
  validates :first_name, :second_name, :third_name,
            :email, :start_point, :end_point,
            :price, :distance,
            absence: false
  validates :phone, format: { with: /\A[0-9]*\z/ }
end
