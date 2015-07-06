FactoryGirl.define do

  factory :store do
    sequence(:name) {|n| Faker::Name.name }
  end

end