class ShowSerializer < ActiveModel::Serializer  
  embed :ids

  attributes :id, :name, :slug, :star_count, :mobile_poster_image_url, :mobile_thumb_image_url, :active
  has_many :characters, embed_key: :slug, key: :character_slugs
  has_many :episodes, embed_key: :slug, key: :episode_slugs


  def star_count
    object.stars.count
  end

  def active
    object.verified? && object.approved?
  end

end