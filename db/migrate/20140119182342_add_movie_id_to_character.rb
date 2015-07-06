class AddMovieIdToCharacter < ActiveRecord::Migration
  def change
    add_reference :characters, :movie_id, index: true
  end
end
