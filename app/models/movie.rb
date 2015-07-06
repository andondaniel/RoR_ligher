# == Schema Information
#
# Table name: movies
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  flag         :boolean
#  verified     :boolean
#  slug         :text
#  deleted_at   :datetime
#  tagline      :string(255)
#  creator_id   :integer
#  approved     :boolean
#  completed    :boolean
#  paid         :boolean
#  release_date :datetime
#  air_length   :integer
#

class Movie < ActiveRecord::Base
	acts_as_paranoid
  include Reviewable

  # Search related
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false

  # has_many :movie_links
  has_many :active_admin_comments, as: :resource, dependent: :destroy
  has_and_belongs_to_many :producers
  has_and_belongs_to_many :directors
  has_many :movie_images
  has_many :characters, -> { order('importance asc') }
  has_many :scenes
  has_many :outfits, through: :scenes
  has_many :products, through: :outfits
  accepts_nested_attributes_for :movie_images, allow_destroy: true
  accepts_nested_attributes_for :characters, allow_destroy: true
  accepts_nested_attributes_for :scenes, allow_destroy: true

  has_many :durations, through: :scenes

  has_many :stars, as: :starable

  scope :active,    -> { verified.approved }

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  after_save :update_slug
  after_save :update_verification

  def to_param
    slug
  end

  def to_label
    slug
  end

  def primary_image(image_size)
    image = self.movie_images.find_by_primary(true) || self.movie_images.first
    image.avatar(image_size)
  end


  def missing_verifications
    conditions = {"Missing name" => name.present?, "Less than 3 approved outfits" => (outfits.approved.length > 3), "Missing movie image" => movie_images.any?}

    missing_conditions =[]
    
    conditions.each do |key, value|
      missing_conditions << key unless value
    end

    missing_conditions = missing_conditions.any? ? missing_conditions : ["All verification conditions met"]
  end

  #what do we want to check in movie verification?
  def update_verification
    if name.present? && (outfits.verified.length > 3) && movie_images.poster.present?
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    return true
  end

  def update_slug
    update_column(:slug, "#{id}-#{name.parameterize}")
  end




  #image methods for easy api call
  def mobile_poster_image_url
    self.movie_images.poster.any? ? self.movie_images.poster.first.avatar.url(:mobile_poster) : nil
  end

  def mobile_thumb_image_url
    self.movie_images.poster.any? ? self.movie_images.poster.first.avatar.url(:mobile_thumb) : nil
  end

  def mobile_cover_image_url
    self.movie_images.cover.any? ? self.movie_images.cover.first.avatar.url(:mobile_full) : nil
  end

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end
  
end
