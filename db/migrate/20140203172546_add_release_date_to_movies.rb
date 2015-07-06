class AddReleaseDateToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :release_date, :datetime
  end
end
