# == Schema Information
#
# Table name: producers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Producer < ActiveRecord::Base
	has_and_belongs_to_many :movies

	# TODO
  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
  	{
  		id: self.id,
  		text: self.name
  	}
  end
end
