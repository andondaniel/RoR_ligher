# == Schema Information
#
# Table name: networks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  creator_id :integer
#  approved   :boolean          default(FALSE)
#  verified   :boolean          default(FALSE)
#

class Network < ActiveRecord::Base
  has_many :shows
  include Reviewable
  validates :name, presence: true

  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
  	{
  		id: self.id,
  		text: self.name
  	}
  end
end
