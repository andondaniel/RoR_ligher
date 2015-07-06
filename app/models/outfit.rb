# == Schema Information
#
# Table name: outfits
#
#  id           :integer          not null, primary key
#  start_time   :integer
#  end_time     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  character_id :integer
#  change       :string(255)
#  verified     :boolean
#  approved     :boolean          default(FALSE)
#  deleted_at   :datetime
#  flag         :boolean
#  creator_id   :integer
#  slug         :string(255)
#  featured     :boolean          default(FALSE)
#

class Outfit < ActiveRecord::Base
  acts_as_paranoid
  include Reviewable

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }
  scope :contains_exact_match, -> { where(contains_exact_match: true) }
  def as_json(options={})
    { id: self.id, text: self.slug }
  end

  def update_contains_exact_match
    update_column(:contains_exact_match, outfit_products.exact_match.any?)
  end

  has_many :active_admin_comments, as: :resource, dependent: :destroy
  # Search related
  # where did the search related stuff go?
  belongs_to  :character
  has_one     :show, through: :character
  has_one     :movie, through: :character
  has_many    :outfit_products
  has_many    :products, through: :outfit_products
  has_many    :outfit_images, dependent: :destroy

  has_many :stars, as: :starable
  has_many :comments, as: :commentable

  has_and_belongs_to_many :scenes
  has_many :episodes, through: :scenes

  accepts_nested_attributes_for :outfit_images, allow_destroy: true
  accepts_nested_attributes_for :outfit_products, allow_destroy: true

  after_save :update_verification
  after_save :update_slug
  after_save :update_contains_exact_match

  validate :character_scene_source_consistency
  
  def character_scene_source_consistency
    if movie
      scenes.each do |s|
        if s.movie != movie
          errors.add(:outfit,"outfits cannot belong to a scene of a show/movie which doesn't contain their character")
        end
      end
    elsif show
      scenes.each do |s|
        if s.show != show
          errors.add(:outfit,"outfits cannot belong to a scene of a show/movie which doesn't contain their character")
        end
      end
    end
    return true
  end

  def update_slug
    update_column(:slug, ["outfit", id].join("-"))
  end


  def admin_permalink
    admin_post_path(self)
  end

  def active_products
    products.active
  end

  def missing_verifications
    conditions = {"Missing active products" => active_products.any?, "Missing episode(s)" => episodes.any?, "Missing character" => character.present?, "Missing outfit image" => outfit_images.present? }

    missing_conditions =[]
    
    conditions.each do |key, value|
      missing_conditions << key unless value
    end

    missing_conditions = missing_conditions.any? ? missing_conditions : ["All verification conditions met"]
  end

  def update_verification
    if active_products.any? && character.present? && outfit_images.any? && (episodes.any? || movie.present?)
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    if episodes.any?
      episodes.map(&:update_verification)
    end
    if character.present?
      character.update_verification
    end
    if movie.present?
      movie.update_verification
    end
    return true
  end

  # This allows adding existing products to an outfit via formtastic
  attr_reader :existing_products_exact
  def existing_products_exact=(product_ids)
    ids = product_ids.select{|p| !p.blank?}
    unless ids.blank?
      ids.each do |id|
        self.outfit_products.build(exact_match: true, product_id: id)
      end
    end
  end
  attr_reader :existing_products_non_exact
  def existing_products_non_exact=(product_ids)
    ids = product_ids.select{|p| !p.blank?}
    unless ids.blank?
      ids.each do |id|
        self.outfit_products.build(exact_match: false, product_id: id)
      end
    end
  end

  def to_label
    "Outfit #{self.id}"
  end

  def to_s
    "Outfit #{self.id}"
  end

  def has_exact_match?
    outfit_products.detect{ |op| op.exact_match}
  end

  def filter_attributes
    attrs = []
    attrs << character.gender rescue "male"
    attrs << character.name
    attrs += episodes.map(&:id)
    attrs.flatten.to_json
  end

  #image methods for easy api call
  def mobile_thumb_image_url
    self.outfit_images.any? ? self.outfit_images.first.avatar.url(:mobile_thumb) : nil
  end

  def mobile_full_image_url
    self.outfit_images.any? ? self.outfit_images.first.avatar.url(:mobile_full) : nil
  end

  def recent_airdate
    ep = episodes.select{|e| e.airdate != nil}.max_by { |e| e.airdate}
    ep.airdate rescue 30.years.ago #if the outfit has no episodes, make it appear last (really just for incomplete data)
  end


end
