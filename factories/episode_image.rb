include ActionDispatch::TestProcess 

FactoryGirl.define do

	factory :episode_image do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'episode_image_primary.png'), 'image/png') }
    primary true
	end
	
end