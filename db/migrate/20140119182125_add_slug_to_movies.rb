class AddSlugToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :slug, :text
  end
end
