class PropImage < ActiveRecord::Base
  belongs_to :prop, touch: true
  include ImageValidator

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    thumb: ['150x150>', :jpg],
    square: ['400x400>', :jpg],
    medium: ['300x300>', :jpg],
    mobile_thumb: ['285x330>', :jpg],
    mobile_full: ['640x750#', :jpg],
    search_square: ['275x275>', :jpg],
    js_popup: ['200x200>', :jpg],
    quickview: ['210x210', :jpg]
  }

  process_in_background :avatar

  validates_attachment_presence :avatar
  validates_attachment :avatar,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }
  # validate :width_valid? #uncomment when we have validations to add
  # validate :height_valid?
  # validate :ratio_valid?


  def width_valid?
    width_validator({})
  end

  def height_valid?
    heigth_validator({})
  end

  def ratio_valid?
    ratio_validator({})
  end
end
