class QuizImage < ActiveRecord::Base

	include ImageValidator
  belongs_to :quiz

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    cover: '960x400>',
  }

  process_in_background :avatar

  #must be after has_atached block
  validates_attachment_presence :avatar
  validates_attachment :avatar, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  validate :width_valid?
  validate :height_valid?
  validate :ratio_valid?


  def width_valid?
    width_validator({}, 960)
  end

  def height_valid?
    heigth_validator({}, 400)
  end

  def ratio_valid?
    ratio_validator({}, (12.0/5.0))
  end

end
