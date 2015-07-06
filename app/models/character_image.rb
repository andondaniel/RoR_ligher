# == Schema Information
#
# Table name: character_images
#
#  id                  :integer          not null, primary key
#  url                 :text
#  alt_text            :string(255)
#  thumbnail           :boolean
#  character_id        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  cover               :boolean
#  verified            :boolean
#

class CharacterImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :character
  validates_uniqueness_of :thumbnail, scope: :character_id, conditions: -> { where.not(thumbnail: false) } #validates that there is only one primary image per character
  validates_uniqueness_of :cover, scope: :character_id, conditions: -> { where.not(cover: false) } 


  scope :thumbnail, -> { where(thumbnail: true) }
  scope :cover, -> { where(cover: true) }

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200>',
    medium: '400x400>',
    mobile_thumb: '80x80>',
    mobile_full: '640x330>',
    mobile_medium: '300x300>',
    small_thumb: '50x50>'
  }

  process_in_background :avatar


  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?


  def width_valid?
    width_validator({:cover => 1000, :thumbnail => 500})
  end

  def height_valid?
    heigth_validator({:cover => 375, :thumbnail => 500})
  end

  def ratio_valid?
    ratio_validator({:thumbnail => 1})
  end

  # validate :avatar_dimensions_valid?

  # def avatar_dimensions_valid?
  #   width_valid?({:cover => 1000, :thumbnail => 500})
  #   heigth_valid?({:cover => 375, :thumbnail => 500})
  #   ratio_valid?({:thumbnail => 1})
  # end


  # def avatar_dimensions_valid?
  #   if avatar.queued_for_write[:original]
  #     dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
  #   #added to make sure avatar original wasn't just returning the default missing png
  #   elsif avatar(:original) && (avatar(:original) != "/avatars/original/missing.png")
  #     avatar_path = (avatar.options[:storage] == :s3) ? avatar.url(:original) : avatar.path(:original)
  #     dimensions = Paperclip::Geometry.from_file(avatar_path)
  #   end
  #   #if dimensions haven't been defined that means there is no avatar file. It will return an error based on the first validation
  #   if dimensions
  #     if self.cover
  #       if dimensions.width < 1000.0 || dimensions.height < 375.0
  #         errors.add(:file,'Width must be at least 1000px and height must be at least 375px')
  #       end
  #     end
  #     if self.thumbnail
  #       if dimensions.width < 500.0 || dimensions.height < 500.0
  #         errors.add(:file,'Width must be at least 500px and height must be at least 500px')
  #       end
  #       if (dimensions.width / dimensions.height != 1)
  #         errors.add(:file, 'The width to height ratio for this image must be 1:1')
  #       end
  #     end
  #   end
  # end

end
