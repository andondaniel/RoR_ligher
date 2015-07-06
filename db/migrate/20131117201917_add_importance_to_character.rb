class AddImportanceToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :importance, :integer
  end
end
