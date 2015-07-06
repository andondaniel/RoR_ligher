class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :star_count, :description, :actor, :gender, :guest, :mobile_medium_image_url, :mobile_thumb_image_url, :mobile_full_image_url, :importance, :active
  has_many :outfits, embed: :ids


  def star_count
    object.stars.count
  end

  def active
    object.verified? && object.approved?
  end

  def outfits
    if object.show.present?
  	 object.outfits.sort_by{|o| o.recent_airdate}.reverse
    else
      object.outfits
    end
  end

end