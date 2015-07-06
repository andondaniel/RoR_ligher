class CreatePropImages < ActiveRecord::Migration
  def change
    create_table :prop_images do |t|
      t.string :url
      t.string :alt_text
      t.references :prop, index: true

      t.timestamps
    end
  end
end
