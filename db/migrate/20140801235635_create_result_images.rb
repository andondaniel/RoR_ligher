class CreateResultImages < ActiveRecord::Migration
  def change
    create_table :result_images do |t|
      t.references :result, index: true
      t.text :url
      t.text :alt_text

      t.timestamps
    end
  end
end
