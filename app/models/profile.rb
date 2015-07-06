# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base
  belongs_to :user

  validates :first_name, :last_name, presence: true

  # TODO
  scope :finder, lambda { |q| where("first_name ILIKE :q or last_name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("first_name ILIKE :q or last_name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def name
    first_name + " " + last_name
  end

  def as_json(options={})
    if options[:profile].blank?
    	{
    		id: self.user_id,
    		text: self.name
    	}
    else 
      {
        id: self.id,
        text: self.name
      }
    end
  end

end
