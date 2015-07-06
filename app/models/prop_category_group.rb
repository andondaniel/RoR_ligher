class PropCategoryGroup < ActiveRecord::Base
	has_and_belongs_to_many :prop_categories, join_table: "prop_categories_prop_category_groups"
end
