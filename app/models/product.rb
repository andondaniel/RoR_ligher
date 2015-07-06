# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  qr_code        :text
#  character_id   :integer
#  brand_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#  slug           :string(255)
#  verified       :boolean
#  approved       :boolean          default(FALSE)
#  deleted_at     :datetime
#  flag           :boolean
#  creator_id     :integer
#  product_set_id :integer
#

class Product < ActiveRecord::Base
  acts_as_paranoid
  include Reviewable

  # self.per_page = 10

  # Search related
  include Tire::Model::Search
  include Tire::Model::Callbacks

  settings :analysis => {
          :analyzer => {
            :default => {
              :type => 'snowball'
            }
          }
        } do
      mapping do
        indexes :name, boost: 10
        indexes :description, boost: 1
        indexes :slug
        indexes :approved
        indexes :created_at, type: 'date'
        indexes :updated_at, type: 'date'

        indexes :characters do
          indexes :name, boost: 50
        end

        indexes :shows do
          indexes :name, boost: 50
        end
        indexes :colors do
          indexes :name, boost: 100
        end
      end
    end


  self.include_root_in_json = false
  after_touch { tire.update_index } # update search index when modified

  has_many :active_admin_comments, as: :resource, dependent: :destroy
  belongs_to :brand
  belongs_to :product_set
  has_and_belongs_to_many :product_categories
  has_and_belongs_to_many :colors
  has_many :product_images, dependent: :destroy
  has_many :product_sources, as: :sourceable, dependent: :destroy, class_name: "Source"
  has_many :outfit_products
  has_many :outfits, through: :outfit_products
  has_many :episodes, through: :outfits, counter_cache: true
  has_many :characters, through: :outfits, counter_cache: true
  has_many :shows, through: :characters
  has_many :movies, through: :characters

  has_many :stars, as: :starable
  has_many :product_ratings
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :product_images, allow_destroy: true
  accepts_nested_attributes_for :product_sources, allow_destroy: true
  accepts_nested_attributes_for :outfits, allow_destroy: true #not valid with HABTM

  scope :deleted,     -> { unscoped.where("deleted_at is not null")}

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }


  scope :in_category_group, lambda{ |cg| Product.joins( :product_categories).where({:product_categories => {:id => cg.product_category_ids}}).distinct }
  # verification status should be updated any time product is saved
  # this method should also be called any time a dependent model is saved
  # as its verification status could affect that of the product
  after_save :update_verification
  after_save :update_slug
  after_save { |product| product.product_sources.each {|ps| ps.save } }

  def to_indexed_json
    to_json(include: {characters: {only: [:name]}, shows: {only: [:name]}, colors: {only: [:name]}})
  end

  def to_param
    slug
  end

  def to_label
    slug
  end

  def gender
    product_categories.first.gender rescue nil
  end

  def average_rating
    ratings = self.product_ratings.map{ |pr| pr.value}
    average = (ratings.count == 0) ? 0 : ratings.inject { |sum, x| sum + x }.to_f / ratings.count
  end

  def missing_verifications
    conditions = {"Missing name" => name.present?, "Missing product image" => product_images.any?, "Missing brand" => brand.present?, "Missing description" => description.present?, "Missing valid product source" => product_sources.valid.any?, "Missing store for product source" => product_sources.first.store.present?, "Missing product source with non-zero price" => (product_sources.first.price != 0.00), "Missing product category" => product_categories.any? }

    missing_conditions =[]
    
    conditions.each do |key, value|
      missing_conditions << key unless value
    end

    missing_conditions = missing_conditions.any? ? missing_conditions : ["All verification conditions met"]
  end

  #This should incorporate valid product source checks at a later date (i.e. once we make product source validity a thing)
  def update_verification
    if (name.present? && product_images.any? && brand.present? && description.present? && product_sources.valid.any? && product_sources.first.store.present? && (product_sources.first.price != 0.00) && product_categories.any?)
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    # Outfits and characters depend on products for their verification status,
    # so update those as well
    if outfits
      outfits.map(&:update_verification)
    end
    if characters
      characters.map(&:update_verification)
    end
    return true
  end

  def update_slug
    update_column(:slug,  [id, name.parameterize].join("-"))
  end

  def filter_attributes
    attrs = []
    attrs << characters.first.gender rescue "male"
    attrs += characters.map(&:name)
    attrs += product_categories.map(&:name)
    attrs.flatten.to_json
  end

  def exact_match?(outfit)
    outfit.outfit_products.where(product_id: id, exact_match: true).any?
  end

  def price
    price = String.new
    if product_sources.any?
      price = self.product_sources.map { |source| source.price }.min.format
    else
      nil
    end
    if price == "$0.01"
      price = "No Price Available"
    end
    return price
  end

  def sortable_price
    if product_sources.any?
      price = self.product_sources.map { |source| source.price.cents }.min
    else
      nil
    end
    if price == 1
      price = nil
    end
    return price
  end

  def any_stock
    if product_sources.any?
      stock = product_sources.first.in_stock
    else
      stock = false
    end
    return stock
  end

  def similar_products
    if self.product_set
      self.product_set.products.delete_if {|product| product.id == self.id }
    else
      nil
    end
  end

  # the last episode in which the product appeared
  def last_episode
    episodes.select{|e|e.airdate}.sort_by{|e| e.airdate}.last || episodes.first
  end


  # to get the last outfit in which this product appeared
  def last_outfit
    if self.outfits.active.any?
      self.outfits.active.where(episodes == last_episode).last
    else nil
    end
  end


  def cheaper_products
    if self.product_set
      self.product_set.products.select do |product|
        if product.product_sources.any? && product.price
          product.price < self.price
        end
      end
    else
      nil
    end
  end


  #image methods for easy api call
  def mobile_thumb_image_url
    self.product_images.any? ? self.product_images.first.avatar.url(:mobile_thumb) : nil
  end

  def mobile_full_image_url
    self.product_images.any? ? self.product_images.first.avatar.url(:mobile_full) : nil
  end

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end
end
