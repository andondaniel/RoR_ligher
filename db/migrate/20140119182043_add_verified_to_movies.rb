class AddVerifiedToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :verified, :boolean
  end
end
