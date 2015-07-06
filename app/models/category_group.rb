# == Schema Information
#
# Table name: category_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  gender     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CategoryGroup < ActiveRecord::Base
	has_and_belongs_to_many :product_categories

	scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }


	def products
    Product.in_category_group(self)
  end

  def as_json(options={})
    {
      id: self.id,
      text: self.gender + ": " + self.name
    }
  end

  def to_s
  	"#{gender}: #{name}"
  end

  def to_label
  	"#{gender}: #{name}"
  end
  
end
