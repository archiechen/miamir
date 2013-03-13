FactoryGirl.define do
  factory :task do
    title "one task"
    description "one task description"
    
    factory :progress_task do
      status "Progress"
      association :owner,factory: :user
      
      after(:create) do |task|
        task.durations << FactoryGirl.create(:duration, :owner=>task.owner)
      end
    end

    factory :paired_task do
      status "Progress"
      association :owner,factory: :user
      association :partner,factory: :user
      
      after(:create) do |task|
        task.durations << FactoryGirl.create(:duration, :owner=>task.owner,:partner => task.partner)
      end
    end

 end
end