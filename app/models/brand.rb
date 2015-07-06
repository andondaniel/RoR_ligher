# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  creator_id :integer
#

class Brand < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false

  has_many :products
  has_many :active_admin_comments, as: :resource, dependent: :destroy
  validates_uniqueness_of :name, :case_sensitive => false
  belongs_to :creator, class_name: "User"


  after_save :update_slug

  scope :finder, lambda { |q| where("slug ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("slug ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    {
      id: self.id,
      text: self.slug
    }
  end

	def to_param
		slug
	end

  def admin_permalink
    admin_post_path(self)
  end


  def update_slug
    update_column(:slug, name.parameterize)
  end
  
end