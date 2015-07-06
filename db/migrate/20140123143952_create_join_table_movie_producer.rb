class CreateJoinTableMovieProducer < ActiveRecord::Migration
  def change
    create_join_table :movies, :producers do |t|
      # t.index [:movie_id, :producer_id]
      # t.index [:producer_id, :movie_id]
    end
  end
end
