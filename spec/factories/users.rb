# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    second_name { Faker::Name.middle_name }
    third_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { '000000000' }
    password { Faker::Internet.password }
    role { 'operator' }
    organization_id { nil }

    trait :orgadmin do
      role { 'orgadmin' }
    end

    factory :orgadmin, traits: [:orgadmin]
  end
end
