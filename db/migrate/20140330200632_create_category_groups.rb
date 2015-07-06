class CreateCategoryGroups < ActiveRecord::Migration
  def change
    create_table :category_groups do |t|
    	t.string :name
    	t.string :gender
      t.timestamps
    end

    create_table :category_groups_product_categories, id: false do |t|
      t.references :category_group, index: true
      t.references :product_category, index: true
    end

  end
end
