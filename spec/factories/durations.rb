# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :duration do
    minutes nil
    task_id 1
    owner_id 1
  end
end
