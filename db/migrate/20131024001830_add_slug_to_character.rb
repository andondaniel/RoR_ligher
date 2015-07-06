class AddSlugToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :slug, :string
    add_index :characters, :slug
  end
end
