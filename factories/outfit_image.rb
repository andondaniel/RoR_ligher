include ActionDispatch::TestProcess 

FactoryGirl.define do

	factory :outfit_image do
		avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'outfit_image.jpg'), 'image/jpg') }
	end
	
end