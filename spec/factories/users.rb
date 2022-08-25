# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Petr' }
    second_name { 'Petrov' }
    third_name { 'Petrovich' }
    email { 'petr@mail.com' }
    phone { '1111' }
    password { '12345678' }
  end
end
