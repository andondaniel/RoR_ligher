require 'faker'
FactoryGirl.define do

  factory :user, aliases: [:creator] do
    profile
    sequence(:email) {|n| "email#{n}@factory.com" }
    password '123'
    password_confirmation '123'
  end

  factory :user_favorited, class: User do
    email {Faker::Internet.email}
    password  { 'secretpassword' }
    password_confirmation  { 'secretpassword' }
    after(:create) do |user|
      user.favorited_products << [FactoryGirl.create(:product), FactoryGirl.create(:product)]
      user.favorited_outfits << [FactoryGirl.create(:outfit_with_active_product),FactoryGirl.create(:outfit_with_active_product),
                                 FactoryGirl.create(:outfit_with_active_product), FactoryGirl.create(:outfit_with_active_product)]
      user.favorited_shows << [FactoryGirl.create(:show)]
      user.favorited_characters << [FactoryGirl.create(:character), FactoryGirl.create(:character), FactoryGirl.create(:character)]
    end
  end

end