class CreateEpisodeLinks < ActiveRecord::Migration
  def change
    create_table :episode_links do |t|
      t.text :url
      t.string :title
      t.string :alt_text
      t.references :episode, index: true

      t.timestamps
    end
  end
end
