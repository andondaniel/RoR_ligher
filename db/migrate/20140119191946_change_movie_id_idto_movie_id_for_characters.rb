class ChangeMovieIdIdtoMovieIdForCharacters < ActiveRecord::Migration
  def change
  	rename_column :characters, :movie_id_id, :movie_id
  end
end
