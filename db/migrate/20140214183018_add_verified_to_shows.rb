class AddVerifiedToShows < ActiveRecord::Migration
  def change
    add_column :shows, :verified, :boolean
  end
end
