# == Schema Information
#
# Table name: product_sources
#
#  id             :integer          not null, primary key
#  url            :text
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  status         :string(255)
#  store_id       :integer
#  product_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  in_stock       :boolean
#

class Source < ActiveRecord::Base
  belongs_to :store


  belongs_to :sourceable, :polymorphic => true
  validates_inclusion_of :sourceable_type, :in => ["Product", "Prop"]

  attr_accessor :new_price_value, :new_price_currency, :link_checked
  monetize :price_cents, :with_model_currency => :price_currency
  before_save :update_price
  before_save :update_link_last_checked
  
  scope :valid, -> { where("status ILIKE 'valid%'") }
  scope :invalid, -> { where("status ILIKE 'invalid%'") }
  scope :in_stock, -> { where(in_stock: true)}
  scope :available, -> { where(available: true)}
  scope :unavailable, -> { where(available: false)}

  # after_save :update_validity
  # after_save :verify_product

  def admin_permalink
    admin_post_path(self)
  end

  def product
    if sourceable_type == "Product"
      sourceable
    else
      nil
    end
  end

  def prop
    if sourceable_type == "Prop"
      sourceable
    else
      nil
    end
  end

  def update_validity
    request = Typhoeus::Request.new(URI.encode(self.url), followlocation: true)
    status = ""
    request.on_complete do |response|
      if response.success?
        status = "valid - (#{response.code})"
      elsif response.timed_out?
        status = "invalid - timeout (#{response.code})"
      elsif response.code == 0
        status = "invalid - unknown (#{response.code})"
      else
        status = "invalid (#{response.code})"
      end
    end
    request.run
    self.update_column(:status, status)
  end

  def update_price
    if self.new_price_value && self.new_price_currency
      self.price = Monetize.parse( new_price_value + new_price_currency )
    end
  end

  def update_link_last_checked
    if self.link_checked
      self.link_last_checked = Time.now
    end
  end

  def verify_product
    # triggers the product verification through an after save callback
    self.product.update_verification if self.product
    return true
  end

end
