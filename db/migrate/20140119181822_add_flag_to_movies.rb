class AddFlagToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :flag, :boolean
  end
end
