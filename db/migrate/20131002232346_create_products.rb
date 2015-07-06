class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.text :qr_code
      t.string :approval_status
      t.references :episode, index: true
      t.references :character, index: true
      t.references :brand, index: true

      t.timestamps
    end
  end
end
