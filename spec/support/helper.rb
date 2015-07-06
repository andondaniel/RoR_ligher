module Helpers
  def reindex
    Show.tire.index.delete
    Show.create_elasticsearch_index
    Show.all.each do |s|
      s.tire.update_index
    end
    Show.tire.index.refresh

    Episode.tire.index.delete
    Episode.create_elasticsearch_index
    Episode.all.each do |s|
      s.tire.update_index
    end
    Episode.tire.index.refresh

    Character.tire.index.delete
    Character.create_elasticsearch_index
    Character.all.each do |s|
      s.tire.update_index
    end
    Character.tire.index.refresh

    ProductCategory.tire.index.delete
    ProductCategory.create_elasticsearch_index
    ProductCategory.all.each do |s|
      s.tire.update_index
    end
    ProductCategory.tire.index.refresh

    Product.tire.index.delete
    Product.create_elasticsearch_index
    Product.all.each do |s|
      s.tire.update_index
    end
    Product.tire.index.refresh
  end
end