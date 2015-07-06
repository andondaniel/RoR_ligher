FactoryGirl.define do

  factory :episode do
    sequence(:season) { |n| n }
    sequence(:episode_number) { |n| n }
    sequence(:name) { |n| "name_#{n}" }
    episode_images {[FactoryGirl.create(:episode_image)]}
    airdate {Time.now - 1.day }
    show
  end

  factory :episode_for_home, class: Episode do
    sequence(:season) { |n| n }
    sequence(:episode_number) { |n| n }
    sequence(:name) {|n| "name_#{n}"}
    episode_images {[FactoryGirl.create(:episode_image)]}
    airdate {Time.now - 1.day }
  end


  factory :episode_for_show, class: Episode do
    sequence(:season) { |n| n }
    sequence(:episode_number) { |n| n }
    sequence(:name) {|n| "name_#{n}"}
    verified true
    approved true
    airdate {Time.now - 1.day}
    show
  end

end
