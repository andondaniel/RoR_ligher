# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  deleted_at :datetime
#  approved   :boolean
#  flag       :boolean
#  creator_id :integer
#  network_id :integer
#  verified   :boolean
#  featured   :boolean
#

class Show < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail :if => Proc.new { |t| t.approved_changed? && t.approved }
  include Reviewable

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  # Search related
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false

  has_many :active_admin_comments, as: :resource, dependent: :destroy
  belongs_to :network
  has_many :characters, -> { order('importance asc') }
  has_many :episodes, -> { order('season desc, episode_number desc') }
  has_many :show_images
  validates_uniqueness_of :name, :case_sensitive => false, conditions: -> { where(deleted_at: nil) }
  accepts_nested_attributes_for :show_images, allow_destroy: true
  accepts_nested_attributes_for :characters, allow_destroy: true

  has_many :stars, as: :starable

  after_save :update_slug
  after_save :update_verification


  def admin_permalink
    admin_post_path(self)
  end

  def update_slug
    update_column(:slug, name.parameterize)
  end

  def seasons
    episodes.active.map{|ep| ep.season}.uniq.sort
  end

	def to_param
		slug
	end

  #image methods for easy api calls
  def mobile_poster_image_url
    self.show_images.poster.any? ? self.show_images.poster.first.avatar.url(:mobile_poster) : nil
  end

  def mobile_thumb_image_url
    self.show_images.poster.any? ? self.show_images.poster.first.avatar.url(:mobile_thumb) : nil
  end


  def update_verification
    if characters.active.any? && episodes.active.any? && show_images.cover.any?
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    return true
  end

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end
  
end
