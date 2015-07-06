class AddFlagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :flag, :boolean
  end
end
