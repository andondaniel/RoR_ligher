class AddEpsisodeIdToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :episode_id, :integer, index: true
  end
end
