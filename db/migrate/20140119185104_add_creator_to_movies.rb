class AddCreatorToMovies < ActiveRecord::Migration
  def change
  	add_column :movies, :creator_id, :integer, references: :users
  end
end
