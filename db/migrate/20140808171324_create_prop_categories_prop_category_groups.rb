class CreatePropCategoriesPropCategoryGroups < ActiveRecord::Migration
  def change
    create_table :prop_categories_prop_category_groups do |t|
      t.references :prop_category, index: true
      t.references :prop_category_group
    end
    add_index(:prop_categories_prop_category_groups, [:prop_category_id, :prop_category_group_id], unique: true, name: 'pc_pcg_index')
  end
end
