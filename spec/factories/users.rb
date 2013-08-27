# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password '1234qwer'
    password_confirmation { |u| u.password }
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
