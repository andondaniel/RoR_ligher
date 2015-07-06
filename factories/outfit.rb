FactoryGirl.define do
  factory :outfit_with_active_product, class: Outfit do
    sequence(:change) {|n| n}
    products {[FactoryGirl.create(:product_active)]}
    character {FactoryGirl.create(:character)}
    show {character}
    outfit_images {[FactoryGirl.create(:outfit_image)]}
    #episodes{[FactoryGirl.create(:episode_for_home)]}
    approved true
  end

  factory :outfit, class: Outfit do
    sequence(:change) {|n| Faker::Number.number(2)}
    products {[FactoryGirl.create(:product_active)]}
    outfit_images {[FactoryGirl.create(:outfit_image)]}
    # after(:create) {|outfit| outfit.scenes = [FactoryGirl.create(:scene), FactoryGirl.create(:scene)]}
    approved true
  end
	
end