class AddFlagToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :flag, :boolean
  end
end
