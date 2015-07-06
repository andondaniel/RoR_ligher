class AddGenderToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :gender, :string
  end
end
