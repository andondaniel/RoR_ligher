# == Schema Information
#
# Table name: scene_images
#
#  id                  :integer          not null, primary key
#  scene_id            :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  alt_text            :string(255)
#  primary             :boolean
#  cover               :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  verified            :boolean
#

class SceneImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :scene

  has_attached_file :avatar, styles: {
    square: '200x200',
    medium: '300x175>',
    cover: '1000x1000>',
    mobile_thumb: '80x80>',
    mobile_full: '640x330>'
  }

  process_in_background :avatar

  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?


  def width_valid?
    width_validator({}, 1024)
  end

  def height_valid?
    heigth_validator({})
  end

  def ratio_valid?
    ratio_validator({}, (64.0/33.0))
  end


  # validate :avatar_dimensions_valid?

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
  #     if dimensions.width < 1024.0
  #       errors.add(:file,'Width must be at least 1024px')
  #     end
  #     if (dimensions.width / dimensions.height != (64.0 / 33.0))
  #       errors.add(:file, 'The width to height ratio for this image must be 64:33')
  #     end
  #   end
  # end

end
