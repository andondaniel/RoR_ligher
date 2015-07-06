class Prop < ActiveRecord::Base
  include Reviewable
  belongs_to :brand
  has_many :prop_images
  has_many :prop_scenes
  has_many :scenes, through: :prop_scenes
  has_many :episodes, through: :scenes
  has_many :shows, through: :episodes
  has_many :stars, as: :starable
  has_many :active_admin_comments, as: :resource, dependent: :destroy
  has_many :prop_sources, as: :sourceable, dependent: :destroy, class_name: "Source"
  has_and_belongs_to_many :prop_categories


  accepts_nested_attributes_for :prop_images, allow_destroy: true
  accepts_nested_attributes_for :prop_sources, allow_destroy: true
  accepts_nested_attributes_for :prop_scenes, allow_destroy: true


  after_save :update_verification
  after_save :update_slug

  def update_verification
    return true
  end

  def update_slug
    update_column(:slug,  [id, name.parameterize].join("-"))
  end


end
