class AddVerifications < ActiveRecord::Migration
  def change
    add_column :characters, :verified, :boolean
    add_column :episodes,   :verified, :boolean
    add_column :outfits,    :verified, :boolean
    add_column :products,   :verified, :boolean
  end
end
