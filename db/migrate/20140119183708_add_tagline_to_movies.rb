class AddTaglineToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tagline, :text
  end
end
