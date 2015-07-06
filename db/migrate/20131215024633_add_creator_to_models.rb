class AddCreatorToModels < ActiveRecord::Migration
  def change
    add_column :episodes, :creator_id, :integer, references: :users
    add_column :shows, :creator_id, :integer, references: :users
    add_column :characters, :creator_id, :integer, references: :users
    add_column :products, :creator_id, :integer, references: :users
    add_column :outfits, :creator_id, :integer, references: :users
  end
end
