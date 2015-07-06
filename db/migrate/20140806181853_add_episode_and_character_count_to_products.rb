class AddEpisodeAndCharacterCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :episode_count, :integer
    add_column :products, :character_count, :integer
  end
end
