class AddAvailableToProductSource < ActiveRecord::Migration
  def change
    add_column :product_sources, :available, :boolean, default: true
  end
end
