class CreatePropCategoriesProps < ActiveRecord::Migration
  def change
    create_table :prop_categories_props do |t|
      t.references :prop, index: true
      t.references :prop_category, index: true
    end
  end
end
