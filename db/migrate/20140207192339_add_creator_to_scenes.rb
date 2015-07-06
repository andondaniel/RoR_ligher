class AddCreatorToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :creator_id, :integer, references: :users
  end
end
