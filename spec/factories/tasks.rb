FactoryGirl.define do
  factory :task do
    title "one task"
    description "one task description"
    status "Ready"
    estimate 10

    factory :progress_task do
      status "Progress"
    end

    factory :done_task do
      status "Progress"
    end
  end

end