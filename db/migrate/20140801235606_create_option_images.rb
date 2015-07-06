class CreateOptionImages < ActiveRecord::Migration
  def change
    create_table :option_images do |t|
      t.references :option, index: true
      t.text :url
      t.text :alt_text

      t.timestamps
    end
  end
end
