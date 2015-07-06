class AddFlagsToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :flag, :boolean, default: false
  end
end
