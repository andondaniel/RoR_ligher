class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :season
      t.integer :episode_number
      t.string :name
      t.datetime :airdate
      t.references :show, index: true

      t.timestamps
    end
  end
end
