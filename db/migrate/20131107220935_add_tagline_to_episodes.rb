class AddTaglineToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :tagline, :string
  end
end
