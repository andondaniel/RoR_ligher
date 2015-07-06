class AddAttributesToMovieImages < ActiveRecord::Migration
  def change
    add_column :movie_images, :cover, :boolean
    add_column :movie_images, :poster, :boolean
  end
end
