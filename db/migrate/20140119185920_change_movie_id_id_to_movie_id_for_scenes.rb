class ChangeMovieIdIdToMovieIdForScenes < ActiveRecord::Migration
  def change
  	rename_column :scenes, :movie_id_id, :movie_id
  end
end
