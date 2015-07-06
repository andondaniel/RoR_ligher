              include ActionDispatch::TestProcess

FactoryGirl.define do

	factory :scene_image do

		avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'scene_image.jpg'), 'image/jpg') }

	end
	
end