class PropCategory < ActiveRecord::Base
	self.include_root_in_json = false

  has_and_belongs_to_many :props
  has_and_belongs_to_many :prop_category_groups, join_table: "prop_categories_prop_category_groups"
  validates_uniqueness_of :name


  scope :finder, lambda { |q| where("name ILIKE :q", q: "%#{q}%") }
  scope :finder_with_offset, lambda { |q, page, page_limit| where("name ILIKE :q", q: "%#{q}%").offset((page - 1) * page_limit).limit(page_limit) }

  def as_json(options={})
    {
      id: self.id,
      text: self.name
    }
  end
end
