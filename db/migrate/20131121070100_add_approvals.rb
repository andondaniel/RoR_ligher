class AddApprovals < ActiveRecord::Migration
  def change
    remove_column :episodes, :approval_status
    remove_column :products, :approval_status
    add_column :episodes, :approved, :boolean, default: false
    add_column :products, :approved, :boolean, default: false
    add_column :outfits, :approved, :boolean, default: false
    add_column :characters, :approved, :boolean, default: false
  end
end
