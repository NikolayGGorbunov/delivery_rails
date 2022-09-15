# frozen_string_literal: true

class Package < ApplicationRecord
  include AASM

  belongs_to :user

  validates :weight, :width, :length, :height,
            comparison: { greater_than: 0 }
  validates :width, :length, :height,
            numericality: { only_integer: true }
  validates :weight, numericality: true
  validates :start_point, :end_point,
            :price, :distance,
            absence: false

  scope :of_org_by, ->(org_id, group_by = nil) { joins(:user).where(user: { organization_id: org_id }).group(group_by) }

  aasm column: :aasm_state do
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
