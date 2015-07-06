class AddPrimaryToMovieImages < ActiveRecord::Migration
  def change
    add_column :movie_images, :primary, :boolean
  end
end
