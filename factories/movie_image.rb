include ActionDispatch::TestProcess 

FactoryGirl.define do

	factory :movie_image do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'movie_image_cover.jpg'), 'image/jpg') }
  end

  factory :movie_image_poster, class: MovieImage do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'movie_image_poster.jpg'), 'image/jpg') }
    poster true
  end

  factory :movie_image_cover , class: MovieImage do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'movie_image_cover.jpg'), 'image/jpg') }
    cover true
  end
	
end