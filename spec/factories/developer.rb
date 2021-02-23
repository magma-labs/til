# frozen_string_literal: true

FactoryBot.define do
  factory :developer do
    sequence :email do |n|
      "developer#{n}@magmalabs.io"
    end

    sequence :username do |n|
      "username#{n}"
    end
  end
end
