class AddGuestToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :guest, :boolean, default: false
  end
end
