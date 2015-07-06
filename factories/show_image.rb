include ActionDispatch::TestProcess 

FactoryGirl.define do

	factory :show_image do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'show_image_cover.jpg'), 'image/jpg') }
  end

  factory :show_image_cover, class: ShowImage do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'show_image_cover.jpg'), 'image/jpg') }
    cover true
  end

  factory :show_image_poster, class: ShowImage do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'show_image_poster.jpg'), 'image/jpg') }
    poster true
  end
	
end