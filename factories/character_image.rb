include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :character_image do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'character_image_thumb.png'), 'image/png') }
    thumbnail true
  end

  factory :character_image_cover, class: CharacterImage do
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'character_image_cover.jpg'), 'image/png') }
    cover true
  end


end