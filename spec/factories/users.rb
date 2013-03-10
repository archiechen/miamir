FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user#{n}@factory.com" }
    password "woaixuexi"
    password_confirmation "woaixuexi"

    factory :user_hastask do
      association :task, factory: :progress_task
    end
  end
end