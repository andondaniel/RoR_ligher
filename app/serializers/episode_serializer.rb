class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :season, :episode_number, :airdate, :slug, :active, :approved, :verified, :has_aired, :mobile_thumb_image_url
  has_many :episode_links
  has_many :scenes

  def active
  	object.approved && object.verified && object.has_aired
  end

  def has_aired
  	if object.airdate.class == ActiveSupport::TimeWithZone
  		return (object.airdate < Time.now)
  	else
  		return false
  	end
  end
end