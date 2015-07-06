class AddAirLengthToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :air_length, :integer
  end
end
