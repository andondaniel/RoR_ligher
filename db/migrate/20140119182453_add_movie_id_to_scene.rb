class AddMovieIdToScene < ActiveRecord::Migration
  def change
    add_reference :scenes, :movie_id, index: true
  end
end
