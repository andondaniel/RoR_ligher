class AddLinkLastCheckedToProductSources < ActiveRecord::Migration
  def change
    add_column :product_sources, :link_last_checked, :datetime, default: 1.year.ago
  end
end
