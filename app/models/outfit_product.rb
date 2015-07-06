# == Schema Information
#
# Table name: outfits_products
#
#  outfit_id   :integer
#  product_id  :integer
#  id          :integer          not null, primary key
#  exact_match :boolean
#

class OutfitProduct < ActiveRecord::Base
  self.table_name = "outfits_products"
  belongs_to :outfit
  belongs_to :product
  accepts_nested_attributes_for :product, allow_destroy: true

  scope :active, -> { joins(:outfit, :product).where(outfits: {verified: true, approved: true}, products: {verified: true, approved: true}) }
  scope :exact_match, -> { where(exact_match: true) }

  def active?
  	product.verified? && product.approved?
  end

end
