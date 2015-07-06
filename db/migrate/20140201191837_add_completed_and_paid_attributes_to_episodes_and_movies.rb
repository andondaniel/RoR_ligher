class AddCompletedAndPaidAttributesToEpisodesAndMovies < ActiveRecord::Migration
  def change
  	add_column :episodes, :completed, :boolean
  	add_column :movies, :completed, :boolean
  	add_column :episodes, :paid, :boolean
  	add_column :movies, :paid, :boolean
  end
end