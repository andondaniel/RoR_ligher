FactoryGirl.define do

  factory :product_source do
    sequence(:url) {|n| Faker::Internet.url }
    sequence(:price_cents) {|n| Faker::Number.number(4) }
    status 'valid'
    store {FactoryGirl.create(:store)}
  end
end
