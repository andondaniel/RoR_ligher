# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

class Store < ActiveRecord::Base
  has_many :product_sources
  has_many :products, through: :product_sources
  validates_uniqueness_of :name, :case_sensitive => false

  after_save :update_slug

  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }
  
  def update_slug
    update_column(:slug, name.parameterize)
  end

	def to_param
		slug
	end

  def as_json(options={})
    {
      id: self.id,
      text: self.name
    }
  end
end
