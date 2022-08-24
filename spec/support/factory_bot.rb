# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    first_name { 'Petr' }
    second_name { 'Petrov' }
    third_name { 'Petrovich' }
    email { 'petr@mail.com' }
    phone { '1111' }
    weight { 1.0 }
    length { 1 }
    width { 1 }
    height { 1 }
    start_point { 'Moscow' }
    end_point { 'Krasnodar' }
    distance { 1351 }
    price { 1351 }
  end

  factory :user do
    first_name { 'Petr' }
    second_name { 'Petrov' }
    third_name { 'Petrovich' }
    email { 'petr@mail.com' }
    phone { '1111' }
    password { '12345678' }
  end
end
