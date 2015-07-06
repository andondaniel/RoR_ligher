FactoryGirl.define do

  # factory :outfit1, class: Outfit do
  #   change 1
  #
  #   # factory :verified_outfit do
  #   # 	after_create do |outfit|
  #   # 		# create(:product, outfit: outfit) #needs to account for outfit_products
  #   # 		# create(:outfit_image, outfit: outfit)
  #   # 	end
  #   # end
  # end
  #
  # factory :product1, class: Product do
  #   sequence(:name) {|n| "product#{n}" }
  # end

  factory :outfit_product do
    #outfit {[FactoryGirl.create(:outfit)]}
  end

end