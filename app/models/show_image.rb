# == Schema Information
#
# Table name: show_images
#
#  id                  :integer          not null, primary key
#  alt_text            :string(255)
#  show_id             :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verified            :boolean
#  cover               :boolean
#  poster              :boolean
#  landing             :boolean
#

class ShowImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :show

  validates_uniqueness_of :cover, scope: :show_id, conditions: -> { where.not(cover: false) } 
  validates_uniqueness_of :poster, scope: :show_id, conditions: -> { where.not(poster: false) }
  validates_uniqueness_of :landing, scope: :show_id, conditions: -> { where.not(landing: false) }
  # Must be last validation
  
  scope :poster, -> { where(poster: true) }
  scope :cover, -> { where(cover: true) }
  scope :landing, -> { where(landing: true) }

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200',
    medium: '400x400>',
    cover: '1000x1000>',
    mobile_thumb: '200x300>',
    mobile_poster: '300x440>'
  }

  process_in_background :avatar

  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?


  def width_valid?
    width_validator({:cover => 350.0, :poster => 300.0})
  end

  def height_valid?
    heigth_validator({:cover => 200.0, :poster => 440.0})
  end

  def ratio_valid?
    ratio_validator({:cover => 1.75, :poster => (15.0/22.0)})
  end


end
