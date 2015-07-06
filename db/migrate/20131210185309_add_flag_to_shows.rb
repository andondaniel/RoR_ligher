class AddFlagToShows < ActiveRecord::Migration
  def change
    add_column :shows, :flag, :boolean
  end
end
