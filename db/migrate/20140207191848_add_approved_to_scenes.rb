class AddApprovedToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :approved, :boolean, default: false
  end
end
