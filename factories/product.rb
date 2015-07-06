FactoryGirl.define do

  factory :product do
    sequence(:name) { |n| "product#{n}" }
    product_images { [FactoryGirl.create(:product_image)] }
    brand { FactoryGirl.create(:brand) }
    description Faker::Lorem.paragraph
    product_sources { [FactoryGirl.create(:product_source)] }
    product_categories { [FactoryGirl.create(:product_category)] }
    product_set {FactoryGirl.create(:product_set)}
    after(:create) do |product|
      FactoryGirl.create(:outfit_product, product: product)
      FactoryGirl.create(:episode)
    end
  end

  factory :product_active, class: Product do
    sequence(:name) { |n| "product#{n}" }
    product_images { [FactoryGirl.create(:product_image)] }
    brand { FactoryGirl.create(:brand) }
    description Faker::Lorem.paragraph
    product_sources { [FactoryGirl.create(:product_source)] }
    product_categories { [FactoryGirl.create(:product_category)] }
    verified true
    approved true
  end


  factory :product_fail_verification, class: Product do
    sequence(:name) { |n| "product#{n}" }
    product_images { [FactoryGirl.create(:product_image)] }
    product_sources { [FactoryGirl.create(:product_source)] }
    brand { FactoryGirl.create(:brand) }
    description Faker::Lorem.paragraph
  end

  factory :product_for_home, class: Product do
    name Faker::Name.name
    product_images { [FactoryGirl.create(:product_image)] }
    brand { FactoryGirl.create(:brand) }
    description Faker::Lorem.paragraph
    product_sources { [FactoryGirl.create(:product_source)] }
    product_categories { [FactoryGirl.create(:product_category)] }
    product_set {FactoryGirl.create(:product_set)}
    after(:create) do |product|
      FactoryGirl.create(:outfit_product, product: product)
      FactoryGirl.create(:episode)
    end
  end
end
