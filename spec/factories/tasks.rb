FactoryGirl.define do
  factory :task do
    title "one task"
    description "one task description"
    
    factory :progress_task do
      status "Progress"
      association :owner,factory: :user
    end

 end
end