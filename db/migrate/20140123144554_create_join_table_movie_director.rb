class CreateJoinTableMovieDirector < ActiveRecord::Migration
  def change
    create_join_table :movies, :directors do |t|
      # t.index [:movie_id, :director_id]
      # t.index [:director_id, :movie_id]
    end
  end
end
