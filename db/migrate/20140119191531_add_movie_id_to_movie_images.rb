class AddMovieIdToMovieImages < ActiveRecord::Migration
  def change
    add_reference :movie_images, :movie, index: true
  end
end
