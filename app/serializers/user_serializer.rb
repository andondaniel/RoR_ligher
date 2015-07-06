class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_one :profile
  has_many :favorited_products,embed: :ids, embed_key: :slug, key: :favorited_product_slugs
	has_many :favorited_outfits, embed: :ids
	has_many :favorited_shows, embed: :ids, embed_key: :slug, key: :favorited_show_slugs
	has_many :favorited_characters, embed: :ids, embed_key: :slug, key: :favorited_character_slugs
	has_many :favorited_movies, embed: :ids, embed_key: :slug, key: :favorited_show_movies

end
