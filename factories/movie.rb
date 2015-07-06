FactoryGirl.define do

	factory :movie do
		name Faker::Name.name
    movie_images {[FactoryGirl.create(:movie_image), FactoryGirl.create(:movie_image_poster),
                   FactoryGirl.create(:movie_image_cover)]}
    verified true
    approved true
    #outfits { [FactoryGirl.create(:outfit)] }
	end
	
end
