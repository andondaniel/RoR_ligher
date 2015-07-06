class CreateEpisodesProducts < ActiveRecord::Migration
  def change
    create_table :episodes_products, id: false do |t|
    	t.references :episode, index: true
      t.references :product, index: true
    end
  end
end