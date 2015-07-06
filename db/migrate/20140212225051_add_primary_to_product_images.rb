class AddPrimaryToProductImages < ActiveRecord::Migration
  def change
    add_column :product_images, :primary, :boolean
  end
end
