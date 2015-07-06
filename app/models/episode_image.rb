# == Schema Information
#
# Table name: episode_images
#
#  id                  :integer          not null, primary key
#  episode_id          :integer
#  image_type          :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  primary             :boolean
#  cover               :boolean
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verified            :boolean
#

class EpisodeImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :episode

  scope :primary, -> { where(primary: true) }
  scope :cover, -> { where(cover: true) }


  has_attached_file :avatar, styles: {
    thumb: '225x100>',
    square: '200x200',
    medium: '300x175>',
    cover: '1000x1000>',
    mobile_thumb: '640x330>'
  }

  process_in_background :avatar

  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?

  def width_valid?
    width_validator({:primary => 650.0})
  end

  def height_valid?
    heigth_validator({:primary => 350.0})
  end

  def ratio_valid?
    ratio_validator({:primary => (13.0/7.0)})
  end


  # def avatar_dimensions_valid?
  #   #get dimensions for validation
  #   if avatar.queued_for_write[:original]
  #     dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
  #   #added to make sure avatar original wasn't just returning the default missing png
  #   elsif avatar(:original) && (avatar(:original) != "/avatars/original/missing.png")
  #     avatar_path = (avatar.options[:storage] == :s3) ? avatar.url(:original) : avatar.path(:original)
  #     dimensions = Paperclip::Geometry.from_file(avatar_path)
  #   end
  #   #if dimensions haven't been defined that means there is no avatar file. It will return an error based on the first validation
  #   if dimensions
  #     #perform validation for primary episode images
  #     if self.primary
  #       if dimensions.width < 650.0 || dimensions.height < 350.0
  #         errors.add(:file,'Width must be at least 650px and height must be at least 350px')
  #       end
  #       if (dimensions.width / dimensions.height != (13.0 / 7.0))
  #         errors.add(:file, 'The width to height ratio for this image must be 13:7')
  #       end
  #     end
  #   end
  # end

end
