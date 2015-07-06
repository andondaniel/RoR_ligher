class CreateCharacterImages < ActiveRecord::Migration
  def change
    create_table :character_images do |t|
      t.text :url
      t.string :alt_text
      t.boolean :primary
      t.references :character, index: true

      t.timestamps
    end
  end
end
