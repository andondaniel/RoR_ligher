class CreateShowImages < ActiveRecord::Migration
  def change
    create_table :show_images do |t|
      t.string :alt_text
      t.references :show, index: true
    end

    add_attachment :show_images, :avatar
  end
end
