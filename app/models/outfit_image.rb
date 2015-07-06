# == Schema Information
#
# Table name: outfit_images
#
#  id                  :integer          not null, primary key
#  outfit_id           :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verified            :boolean
#

class OutfitImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :outfit, touch: true

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '400x400',
    medium: '150x320#',
    quickview: '210x210',
    cover: '1000x1000>',
    mobile_full: '640x640>',
    mobile_thumb: '300x380#', 
    index_size: '250x317#',
    search_square: '275x275',
    js_popup: '200x200#'
  }

  process_in_background :avatar

  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?


  def width_valid?
    width_validator({}, 400)
  end

  def height_valid?
    heigth_validator({}, 400)
  end

  def ratio_valid?
    dimensions = get_dimensions
    if (dimensions.width / dimensions.height > (1))
      errors.add(:file, 'This image must be taller than it is wide')
    end
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
  #     if dimensions.width < 400.0 || dimensions.height < 400.0
  #       errors.add(:file,'Width must be at least 400px and height must be at least 400px')
  #     end
  #     if (dimensions.width / dimensions.height > (1))
  #       errors.add(:file, 'This image must be taller than it is wide')
  #     end
  #   end
  # end
end
