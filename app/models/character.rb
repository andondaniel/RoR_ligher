# == Schema Information
#
# Table name: characters
#
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
#  featured    :boolean
#

class Character < ActiveRecord::Base
  acts_as_paranoid
  include Reviewable

  # Search related
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false


  settings :analysis => {
          :analyzer => {
            :default => {
              :type => 'snowball'
            }
          }
        } do
        mapping do
          indexes :name
        end
      end


  has_many :active_admin_comments, as: :resource, dependent: :destroy
  belongs_to :show
  belongs_to :movie
  has_many :outfits
  has_many :products, through: :outfits

  has_many :stars, as: :starable

  has_many :character_images, dependent: :destroy
  accepts_nested_attributes_for :character_images, allow_destroy: true

  validates_inclusion_of :gender, :in => ["Male", "Female", nil]
  validates_uniqueness_of :name, scope: [:show_id, :deleted_at], :case_sensitive => false
  validates_uniqueness_of :importance, :allow_nil => true, scope: [:show_id, :deleted_at]

  after_save  :update_slug
  after_save  :update_verification

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end

  def to_indexed_json
    to_json(except: [:description])
  end

  def active?
    verified? && approved?
  end

  def first_name
    name.split(" ").at(0)
  end

  def missing_verifications
    #every character must meet these
    general_conditions = {"Missing verified outfits" => outfits.verified.any?, "Missing thumbnail image" => character_images.thumbnail.any?, "Missing name" => name.present?, "Description not between 10 and 600 characters" => description.length.between?(10,600)}
    #guest characters are exempt
    non_guest_conditions = {"Missing cover image" => character_images.cover.any?}

    #conditions for a specific instance
    specific_conditions = self.guest ? general_conditions : general_conditions.merge(non_guest_conditions)

    missing_conditions =[]

    specific_conditions.each do |key, value|
      missing_conditions << key unless value
    end

    missing_conditions = missing_conditions.any? ? missing_conditions : ["All verification conditions met"]
  end

  def update_verification
    # require a cover image only if not a guest
    guest_conditions  = self.guest ? true : character_images.cover.any?
    all_conditions    = outfits.verified.any? && character_images.thumbnail.any? && name.present? && description.length.between?(10, 600)
    if all_conditions && guest_conditions
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    if show.present?
      show.update_verification
    elsif movie.present?
      movie.update_verification
    end
    return true
  end


  def to_param
    slug
  end

  def thumbnail_image(image_size)
    image = self.character_images.find_by_thumbnail(true) || self.character_images.first
    image.avatar(image_size)
  end

  def update_slug
    update_column(:slug,  [id, name.parameterize].join("-"))
  end


  #image methods for easy api call
  def mobile_thumb_image_url
    self.character_images.thumbnail.any? ? self.character_images.thumbnail.first.avatar.url(:mobile_thumb) : nil
  end

  def mobile_medium_image_url
    self.character_images.thumbnail.any? ? self.character_images.thumbnail.first.avatar.url(:mobile_medium) : nil
  end

  def mobile_full_image_url
    self.character_images.cover.any? ? self.character_images.cover.first.avatar.url(:mobile_full) : nil
  end
end
