class AddDeltedAtToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :deleted_at, :datetime
  end
end
