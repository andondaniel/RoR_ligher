class AddSlugToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :slug, :string
    add_index :scenes, :slug
  end
end
