class AddSearchIndexes < ActiveRecord::Migration
  def up
    execute "
      create index index_brands_on_name on brands using gin(to_tsvector('english', name));
      create index index_characters_on_name on characters using gin(to_tsvector('english', name));
      create index index_product_categories_on_name on product_categories using gin(to_tsvector('english', name));
      create index index_products_on_name on products using gin(to_tsvector('english', name));
      create index index_products_on_description on products using gin(to_tsvector('english', description));
      create index index_shows_on_name on shows using gin(to_tsvector('english', name));
      create index index_stores_on_name on stores using gin(to_tsvector('english', name));"
  end

  def down
    execute "
      drop index index_brands_on_name
      drop index index_characters_on_name
      drop index index_product_categories_on_name
      drop index index_products_on_name
      drop index index_products_on_description
      drop index index_shows_on_name
      drop index index_stores_on_name"
  end
end
