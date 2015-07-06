class AddGenderToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :gender, :string
  end
end
