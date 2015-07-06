class CreateOutfitImages < ActiveRecord::Migration
  def change
    create_table :outfit_images do |t|
      t.references :outfit, index: true
    end
  end
end
