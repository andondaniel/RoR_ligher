class CreateViewSearches < ActiveRecord::Migration
  def up
    execute "CREATE VIEW searches AS SELECT
        brands.id AS searchable_id,
        'Brand' AS searchable_type,
        brands.name AS term
      FROM brands

      UNION

      SELECT
        characters.id AS searchable_id,
        'Character' AS searchable_type,
        characters.name AS term
      FROM characters

      UNION

      SELECT
        product_categories.id AS searchable_id,
        'ProductCategory' AS searchable_type,
        product_categories.name AS term
      FROM product_categories

      UNION

      SELECT
        products.id AS searchable_id,
        'Product' AS searchable_type,
        products.name AS term
      FROM products

      UNION

      SELECT
        products.id AS searchable_id,
        'Product' AS searchable_type,
        products.description AS term
      FROM products

      UNION

      SELECT
        shows.id AS searchable_id,
        'Show' AS searchable_type,
        shows.name AS term
      FROM shows

      UNION

      SELECT
        stores.id AS searchable_id,
        'Store' AS searchable_type,
        stores.name AS term
      FROM stores

      UNION

      SELECT
        episodes.id AS searchable_id,
        'Episode' AS searchable_type,
        episodes.slug AS term
      FROM episodes"
  end

  def down
    execute "drop view searches"
  end
end
