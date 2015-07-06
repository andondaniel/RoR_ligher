# == Schema Information
#
# Table name: colors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  color_code :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Color < ActiveRecord::Base
	has_many :active_admin_comments, as: :resource, dependent: :destroy
 	has_and_belongs_to_many :products
  	validates_uniqueness_of :name, :case_sensitive => false

  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }
	
	def as_json(options={})
		{
			id: self.id,
			text: self.name
		}  	
	end  
end
