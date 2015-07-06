class CreateProps < ActiveRecord::Migration
  def change
    create_table :props do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.references :brand, index: true
      t.boolean :flag
      t.boolean :approved
      t.boolean :verified
      t.references :creator, index: true

      t.timestamps
    end
  end
end
