class AddFlagToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :flag, :boolean
  end
end
