class SourceSerializer < ActiveModel::Serializer
  attributes :id, :price_cents, :price_currency, :status, :price, :url, :in_stock, :sourceable_type, :sourceable_id
  has_one :store

  def price
  	object.price.format
  end
end
