class RemoveDirectorAndProducerFromMovies < ActiveRecord::Migration
  def change
  	remove_column :movies, :producer
  	remove_column :movies, :director
  end
end
