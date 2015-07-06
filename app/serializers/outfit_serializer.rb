class OutfitSerializer < ActiveModel::Serializer
	delegate :params, to: :scope
	attributes :id, :change, :star_count, :mobile_thumb_image_url, :mobile_full_image_url, :active, :recent_airdate
	has_many :products


	def star_count
    object.stars.count
  end
  def active
    object.verified? && object.approved?
  end

  def include_products?
  	!(params[:no_embed] == "true")
	end

  def recent_airdate
    ep = object.episodes.select {|e| e.airdate != nil}.max_by { |e| e.airdate}
    ep.airdate rescue 30.years.ago #if the outfit has no episodes, make it appear last (really just for incomplete data)
  end

end