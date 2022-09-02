# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :packages, dependent: :destroy
  belongs_to :organization, optional: true

  validates :first_name, :second_name, :third_name,
            :phone, :email,
            presence: true
  validates :phone, format: { with: /\A[0-9]*\z/ }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
