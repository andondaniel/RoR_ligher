FactoryGirl.define do
  factory :category_group do
    gender = ["Male", "Female", "Neutral", nil]
    sequence(:name) {|n| Faker::Name.name }
    sequence(:gender) {|n| gender[rand(0 .. 3)] }
  end
end
