FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user#{n}@factory.com" }
    password "woaixuexi"
    password_confirmation "woaixuexi"

    factory :user_hastask do
      association :task, factory: :progress_task
    end
  end

  factory :task do
    title "one task"
    description "one task description"
    status "Ready"

    factory :progress_task do
      status "Progress"
    end

    factory :done_task do
      status "Progress"
    end
  end

end