# frozen_string_literal: true

class Package < ApplicationRecord
  belongs_to :user

  paginates_per 3

  validates :weight, :width, :length, :height,
            comparison: { greater_than: 0 }
  validates :width, :length, :height,
            numericality: { only_integer: true }
  validates :weight, numericality: true
  validates :start_point, :end_point,
            :price, :distance,
            absence: false
end
