FactoryGirl.define do

	factory :scene do
		sequence(:scene_number) {|n| n }
    scene_images {[FactoryGirl.create(:scene_image)]}
	end
	
end