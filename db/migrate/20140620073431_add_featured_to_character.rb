class AddFeaturedToCharacter < ActiveRecord::Migration
  def up
    add_column :characters, :featured, :boolean
    Character.update_all({featured: true}, {id: [76, 81]})
  end


  def down
    remove_column :characters, :featured
  end
end
