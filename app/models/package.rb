# frozen_string_literal: true

class Package < ApplicationRecord
  include AASM

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

  include AASM

  enum aasm_state: {
    accepted: 1,
    returned: 0,
    delivery: 2,
    delivered: 3
  }

  aasm column: :aasm_state, enum: true do
    state :accepted, initial: true
    state :returned
    state :delivery
    state :delivered

    event :returning do
      transitions from: :accepted, to: :returned
    end

    event :delivering do
      transitions from: :accepted, to: :delivery
    end

    event :ending do
      transitions from: :delivery, to: :delivered
    end
  end
end
