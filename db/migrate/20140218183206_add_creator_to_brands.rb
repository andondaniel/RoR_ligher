class AddCreatorToBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :creator_id, :integer, references: :users
  	add_column :questions, :creator_id, :integer, references: :users
  end
end
