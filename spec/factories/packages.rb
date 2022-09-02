# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    first_name { Faker::Name.first_name }
    second_name { Faker::Name.middle_name }
    third_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    weight { 1.0 }
    length { 1 }
    width { 1 }
    height { 1 }
    start_point { 'Moscow' }
    end_point { 'Krasnodar' }
    distance { 1351 }
    price { 1351 }
    aasm_state { 'accepted' }

    trait :accepted do
      aasm_state { 'accepted' }
    end

    trait :returned do
      aasm_state { 'returned' }
    end

    trait :delivery do
      aasm_state { 'delivery' }
    end

    trait :delivered do
      aasm_state { 'delivered' }
    end

    factory :accepted_package, traits: [:accepted]
    factory :returned_package, traits: [:returned]
    factory :delivery_package, traits: [:delivery]
    factory :delivered_package, traits: [:delivered]
  end
end
