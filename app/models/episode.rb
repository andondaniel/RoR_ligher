# == Schema Information
#
# Table name: episodes
#
#  id             :integer          not null, primary key
#  season         :integer
#  episode_number :integer
#  name           :string(255)
#  airdate        :datetime
#  show_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  slug           :string(255)
#  tagline        :string(255)
#  verified       :boolean
#  approved       :boolean          default(FALSE)
#  deleted_at     :datetime
#  flag           :boolean
#  creator_id     :integer
#  paid           :boolean
#  air_length     :integer
#  fc_completed   :boolean
#  as_completed   :boolean
#

class Episode < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail :if => Proc.new { |t| (t.as_completed_changed? && t.as_completed) || (t.fc_completed_changed? && t.fc_completed) || (t.approved_changed? && t.approved) }

  include Reviewable

  # Search related
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false

  has_many :active_admin_comments, as: :resource, dependent: :destroy
  has_many :episode_links
  has_many :episode_images
  belongs_to :show

  # TODO: should an episode only have characters through its outfits?
  # That is, only include the characters who wore an outfit (i.e. appeared) in the episode?
  has_many :characters, through: :show
  has_many :scenes
  has_many :outfits, through: :scenes
  has_many :products, through: :outfits
  accepts_nested_attributes_for :episode_images, allow_destroy: true
  accepts_nested_attributes_for :scenes, allow_destroy: true

  has_many :durations, through: :scenes

  # overloads definition of active in Reviewable module
  scope :has_aired, -> { where("airdate < ?", Time.now) }
  scope :active,    -> { verified.approved.has_aired }
  scope :unpaid,    -> { where(paid: false) }
  scope :paid,    -> { where(paid: true) }

  validates_uniqueness_of :slug, conditions: -> { where(deleted_at: nil) }
  validates_uniqueness_of :episode_number, scope: [:show_id, :season], conditions: -> { where(deleted_at: nil) }

  after_save :update_slug
  after_save :update_verification
  after_save :update_air_length

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    { id: self.id, text: self.slug }
  end

  # after_update :send_as_completed_email, :if => :as_completed_changed? && :as_completed
  # after_update :send_fc_completed_email, :if => :fc_completed_changed? && :fc_completed


  def admin_permalink
    admin_post_path(self)
  end

  # #can't just validate uniqueness of slugs because it validates across deleted episodes
  # def slug_valid?
  #   slug_inspect = "#{show.name}-season#{season}-episode#{episode_number}".parameterize
  #   if Episode.exists? ["slug = ? AND id != ?", slug_inspect, id.to_i]
  #     errors.add(:slug, 'has already been taken')
  #   end
  # end

  def to_param
    slug
  end

  def to_label
    slug
  end

  def to_s
    slug
  end

  def primary_image(image_size)
    image = self.episode_images.find_by_primary(true) || self.episode_images.first
    image.avatar(image_size)
  end

  def missing_verifications
    conditions = {"Missing season" => season.present?, "Missing episode number" => episode_number.present?, "Missing name" => name.present?, "Less than 3 approved outfits" => (outfits.approved.length > 3), "Missing approved show" => show.approved.present?, "Missing primary episode image" => episode_images.primary.present?}

    missing_conditions =[]
    
    conditions.each do |key, value|
      missing_conditions << key unless value
    end

    missing_conditions = missing_conditions.any? ? missing_conditions : ["All verification conditions met"]
  end

  def update_verification
    if season.present? && outfits.active.detect{|o| o.has_exact_match?} && show.approved.present? && airdate.present? && episode_number.present? && name.present? && (outfits.approved.length > 3) && episode_images.primary.present?
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end

    show.update_verification
    return true
  end

  def update_slug
    slug = "#{show.name}-season#{season}-episode#{episode_number}".parameterize
    update_column(:slug,  slug)
    scenes.each do |s|
      s.update_slug
    end
  end

  def update_air_length
    air_length = scenes.max_by { |scene| scene.scene_number }.durations.max_by { |duration| duration.end_time }.end_time rescue nil
    update_column(:air_length, air_length)
  end

  def active?
    verified? && approved?
  end

  #required for the API
  def has_aired
    self.airdate < Time.now
  end

  #for admin emails
  def send_as_completed_email
    AdminMailer.as_complete(self).deliver
  end

  def send_fc_completed_email
    AdminMailer.fc_complete(self).deliver
  end


  #image methods for easy api call
  def mobile_thumb_image_url
    self.episode_images.any? ? self.episode_images.first.avatar.url(:mobile_thumb) : nil
  end

  ##Season Based methods
  def self.exact_match_percent(show, season)
    outfits = Episode.where(show: show).where(season: season).includes(:outfits => :outfit_products).map(&:outfits).flatten
    ops = outfits.map(&:outfit_products).flatten
    exact_ops = ops.select {|op| op.exact_match }
    ((exact_ops.count.to_f / ops.count.to_f) * 100.0).round(2)
  end

  def self.unique_season_products(show, season)
    Episode.where(show: show).where(season: season).includes(:products).map(&:products).flatten.uniq
  end

end
