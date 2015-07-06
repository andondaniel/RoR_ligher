# == Schema Information
#
# Table name: product_images
#
#  id                  :integer          not null, primary key
#  url                 :string(255)
#  alt_text            :string(255)
#  product_id          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  verified            :boolean
#  primary             :boolean
#

class ProductImage < ActiveRecord::Base
  include ImageValidator
  belongs_to :product, touch: true

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

  # def to_label
  # 	self.avatar_file_name
  # end

end
