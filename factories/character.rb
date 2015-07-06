#  id          :integer          not null, primary key
#  name        :string(255)
#  show_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  description :text
#  actor       :string(255)
#  gender      :string(255)
#  importance  :integer
#  verified    :boolean
#  approved    :boolean          default(FALSE)
#  guest       :boolean          default(FALSE)
#  deleted_at  :datetime
#  flag        :boolean
#  creator_id  :integer
#  movie_id    :integer
FactoryGirl.define do

  factory :character do
    sequence(:name) { |n| Faker::Name.name }
    sequence(:actor) { |n| Faker::Name.name }
    gender 'Male'
    sequence(:importance) { Faker::Number.number(5) }
    approved true
    description Faker::Lorem.paragraph
    outfits {[FactoryGirl.create(:outfit)]}
    character_images {[FactoryGirl.create(:character_image), FactoryGirl.create(:character_image_cover)]}
  end

end

