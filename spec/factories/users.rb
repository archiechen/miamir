FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user#{n}@factory.com" }
    password "woaixuexi"
    password_confirmation "woaixuexi"

  end
end