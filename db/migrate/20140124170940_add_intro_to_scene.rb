class AddIntroToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :intro, :boolean
  end
end
