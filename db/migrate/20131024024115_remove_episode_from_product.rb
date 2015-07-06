class RemoveEpisodeFromProduct < ActiveRecord::Migration
  def change
    remove_reference :products, :episode
  end
end
