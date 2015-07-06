class CreatePropCategories < ActiveRecord::Migration
  def change
    create_table :prop_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
