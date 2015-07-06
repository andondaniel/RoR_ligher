class MovieSerializer < ActiveModel::Serializer
  attributes :id, :name, :release_date, :slug, :active, :approved, :verified, :is_released, :tagline, :star_count, :air_length, :mobile_poster_image_url, :mobile_thumb_image_url, :mobile_cover_image_url
  has_many :scenes
  has_many :producers
  has_many :directors


  def star_count
    object.stars.count
  end

  def active
  	object.approved && object.verified && is_released
  end

  def is_released
  	if object.release_date
  		return object.release_date < Time.now
  	else
  		return false
  	end
  end
end