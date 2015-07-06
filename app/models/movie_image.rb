# == Schema Information
#
# Table name: movie_images
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  primary             :boolean
#  movie_id            :integer
#  verified            :boolean
#  cover               :boolean
#  poster              :boolean
#

class MovieImage < ActiveRecord::Base
  include ImageValidator

	belongs_to :movie, touch: true

  # validates_uniqueness_of :cover, conditions: -> { where.not(cover: false) } 
  # validates_uniqueness_of :poster, conditions: -> { where.not(poster: false) }

  scope :poster, -> { where(poster: true) }
  scope :cover, -> { where(cover: true) }

	has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '400x400',
    medium: '150x320#',
    cover: '1000x1000>',
    mobile_thumb: '200x300>',
    mobile_poster: '300x440>',
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
    width_validator({:cover => 350.0, :poster => 300.0})
  end

  def height_valid?
    heigth_validator({:cover => 200.0, :poster => 440.0})
  end

  def ratio_valid?
    ratio_validator({:cover => 1.75, :poster => (15.0/22.0)})
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
  #     if self.cover
  #       if dimensions.width < 350.0 || dimensions.height < 200.0
  #         errors.add(:file,'Width must be at least 350px and height must be at least 200px')
  #       end
  #       if (dimensions.width / dimensions.height != 1.75)
  #         errors.add(:file, 'The width to height ratio for this image must be 350:200')
  #       end
  #     end
  #     if self.poster
  #       if dimensions.width < 300.0 || dimensions.height < 440.0
  #         errors.add(:file,'Width must be at least 300px and height must be at least 440px')
  #       end
  #       if (dimensions.width / dimensions.height != Rational(15, 22))
  #         errors.add(:file, 'The width to height ratio for this image must be 15:22')
  #       end
  #     end
  #   end
  # end

end
