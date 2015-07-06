class AddAirLengthToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :air_length, :integer
  end
end
