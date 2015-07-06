class AddLastUpdaterToProductSets < ActiveRecord::Migration
  def change
    add_reference :product_sets, :last_updater, index: true
  end
end
