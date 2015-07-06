# == Schema Information
#
# Table name: scenes
#
#  id           :integer          not null, primary key
#  start_time   :integer
#  end_time     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  episode_id   :integer
#  deleted_at   :datetime
#  movie_id     :integer
#  scene_number :integer
#  intro        :boolean
#  verified     :boolean
#  flag         :boolean          default(FALSE)
#  approved     :boolean          default(FALSE)
#  creator_id   :integer
#  slug         :string(255)
#

class Scene < ActiveRecord::Base
  acts_as_paranoid
  include Reviewable

  # Search related
  has_many :active_admin_comments, as: :resource, dependent: :destroy
  has_and_belongs_to_many :outfits
  belongs_to :episode
  has_one :show, through: :episode
  belongs_to :movie

  has_many :prop_scenes
  has_many :props, through: :prop_scenes

  has_many :scene_images
  has_many :durations
  accepts_nested_attributes_for :scene_images, allow_destroy: true
  accepts_nested_attributes_for :durations, allow_destroy: true


  delegate :season, :show_id, to: :episode
  validates_uniqueness_of :scene_number, scope: :episode_id, conditions: -> { where(deleted_at: nil) }, if: :has_episode?
  validates_uniqueness_of :scene_number, scope: :movie_id, conditions: -> { where(deleted_at: nil) }, if: :has_movie?



  after_save :update_verification
  after_save :update_slug

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end
  def admin_permalink
    admin_post_path(self)
  end

  def has_movie?
    movie.present?
  end

  def has_episode?
    episode.present?
  end

  def to_s
    #ideally this would check for a movie or episode rather than simply using a rescue, but that adds 2 n + 1 s
    slug rescue "No Episode/Movie association found!"
  end

  def update_slug
    if self.episode && self.scene_number
      slug = "#{self.episode.slug}-scene-#{self.scene_number}".parameterize
    elsif self.movie
      slug = "#{self.movie.slug}-scene-#{self.scene_number}".parameterize
    else
      slug = self.id
    end
    update_column(:slug,  slug)
  end


  def update_verification
    if false #(durations.verified.count == durations.count) && scene_images.any?
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    return true
  end

  #image methods for easy api call
  def mobile_thumb_image_url
    self.scene_images.any? ? self.scene_images.first.avatar.url(:mobile_thumb) : nil
  end

  def mobile_full_image_url
      self.scene_images.any? ? self.scene_images.first.avatar.url(:mobile_full) : nil
  end


end
