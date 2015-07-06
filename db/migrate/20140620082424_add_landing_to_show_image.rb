class AddLandingToShowImage < ActiveRecord::Migration
  def change
    add_column :show_images, :landing, :boolean
  end
end
