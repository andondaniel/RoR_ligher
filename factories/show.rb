FactoryGirl.define do

  factory :show do
    sequence(:name) { |n| "#{Faker::Name.title}_#{n}" }
    verified true
    approved true
    show_images {[FactoryGirl.create(:show_image), FactoryGirl.create(:show_image_cover), FactoryGirl.create(:show_image_poster)]}
  end
	
end