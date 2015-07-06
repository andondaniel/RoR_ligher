class ChangeProductSourcesToSources < ActiveRecord::Migration
   def change
    rename_table :product_sources, :sources
  end 
end
