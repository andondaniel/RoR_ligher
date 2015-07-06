# == Schema Information
#
# Table name: product_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  gender     :string(255)
#

class ProductCategory < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  self.include_root_in_json = false

  has_and_belongs_to_many :products
  has_and_belongs_to_many :category_groups
  validates_uniqueness_of :name, scope: :gender, :case_sensitive => false
  validates_inclusion_of :gender, :in => ["Male", "Female", "Neutral", nil]

  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    {
      id: self.id,
      text: self.gender + ": " + self.name
    }
  end

  def to_s
  	"#{gender}: #{name}"
  end

  def singular?
    if name == name.pluralize.singularize && name != name.pluralize
      return true
    else return false
    end
  end

  def to_label
  	"#{gender}: #{name}"
  end
end
