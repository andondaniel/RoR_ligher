class AddFeaturedToShow < ActiveRecord::Migration
  def up
    add_column :shows, :featured, :boolean
    Show.update_all({featured: true}, {id: [16, 17, 28]})
  end

  def down
    remove_column :shows, :featured
  end
end
