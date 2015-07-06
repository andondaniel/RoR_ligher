class AddAttributesToShowImages < ActiveRecord::Migration
  def change
    add_column :show_images, :cover, :boolean
    add_column :show_images, :poster, :boolean
  end
end
