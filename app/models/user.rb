# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  admin           :boolean
#  auth_token      :string(255)
#  role            :string(255)      default("Basic")
#

require 'securerandom'

class User < ActiveRecord::Base

  has_secure_password

  has_one   :profile, dependent: :destroy
  delegate  :name, :first_name, :last_name, :address, :verified?, to: :profile, allow_nil: true
  accepts_nested_attributes_for :profile

  validates :email, presence: true, uniqueness: true

  validates_inclusion_of :role, :in => ["Basic", "Quality Control", "Fashion Consultant", "Data Manager", "Admin", "Superadmin"]

  has_many :identities, dependent: :destroy
  has_many :products, foreign_key: "creator_id"
  has_many :shows, foreign_key: "creator_id"
  has_many :outfits, foreign_key: "creator_id"
  has_many :characters, foreign_key: "creator_id"
  has_many :episodes, foreign_key: "creator_id"
  has_many :questions, foreign_key: "creator_id"
  has_many :brands, foreign_key: "creator_id"
  has_many :movies, foreign_key: "creator_id"
  has_many :props, foreign_key: "creator_id"

  has_many :product_sets, foreign_key: "last_updater_id"

  has_many :stars
  has_many :favorited_products, through: :stars, source: :starable, source_type: "Product"
  has_many :favorited_props, through: :stars, source: :starable, source_type: "Prop"
  has_many :favorited_outfits, through: :stars, source: :starable, source_type: "Outfit"
  has_many :favorited_shows, through: :stars, source: :starable, source_type: "Show"
  has_many :favorited_characters, through: :stars, source: :starable, source_type: "Character"
  has_many :favorited_movies, through: :stars, source: :starable, source_type: "Movie"

  has_many :comments
  #These may never be used, but are here for completeness' sake
  has_many :commented_products, through: :comments, source: :commentable, source_type: "Product"
  has_many :commented_outfits, through: :comments, source: :commentable, source_type: "Outfit" 

  has_many :quiz_takes

  scope :super_admin,           -> { where(role: "Superadmin") }
  scope :admin,                 -> { where(role: "Admin") }
  scope :data_manager,          -> { where(role: "Data Manager") }
  scope :fashion_consultant,    -> { where(role: "Fashion Consultant") }
  scope :quality_control,       -> { where(role: "Quality Control") }
  scope :basic,                 -> { where(role: "Basic") }

  has_many :active_admin_comments, foreign_key: "author_id"
  has_many :resource_comments, foreign_key: "resource_creator_id", class_name: "ActiveAdminComment"

  def qc_permissions?
    role == "Quality Control" || role == "Fashion Consultant" || role == "Data Manager" || role == "Admin" || role == "Superadmin"
  end

  def fc_permissions?
    role == "Fashion Consultant" || role == "Data Manager" || role == "Admin" || role == "Superadmin"
  end

  def dm_permissions?
    role == "Data Manager" || role == "Admin" || role == "Superadmin"
  end

  def admin_permissions?
    role == "Admin" || role == "Superadmin"
  end

  def super_admin_permissions?
    role == "Superadmin"
  end

  after_create :set_auth_token

  def favorites
    favorites = Hash.new
    favorites[:products] = self.favorited_products
    favorites[:outfits] = self.favorited_outfits
    favorites[:shows] = self.favorited_shows
    favorites[:characters] = self.favorited_characters
    return favorites
  end

  def self.new_from_omniauth(user_info)
    user = User.new
    user_profile = user.build_profile

    if user_info
      user.email = user_info[:email]
      user_profile.first_name = user_info[:first_name]
      user_profile.last_name  = user_info[:last_name]
    end

    return user
  end

  def is_admin?
    self.admin
  end

  # we can't use a has_many :review_items, through: :reviews because it's a
  # polymorphic association for review_items.
  has_many  :reviews, foreign_key: "reviewer_id"
  def review_items
    reviews.map(&:review_item)
  end

  def set_auth_token
    update_column(:auth_token, SecureRandom.hex)
  end

  def worked_shows
    worked_shows = {}
    self.episodes.includes(:show).each do |e|
      worked_shows[e.show] ||= {}
      worked_shows[e.show][e.season] ||= []
      worked_shows[e.show][e.season] << e
    end
    return worked_shows
  end

end
