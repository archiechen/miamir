# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name "Miami"

    factory :team_with_members do
      members {FactoryGirl.create_list(:user,2)}
    end
  end
end
