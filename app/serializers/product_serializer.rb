class ProductSerializer < ActiveModel::Serializer
  delegate :params, to: :scope
  has_many :product_sources
  has_many :product_categories
  has_many :outfits, embed: :ids
  has_many :colors
  has_one :brand
  attributes :id, :name, :description, :approved, :slug, :star_count, :mobile_thumb_image_url, :mobile_full_image_url, :active


  def star_count
    object.stars.count
  end

  def active
    object.verified? && object.approved?
  end

  # def attributes
  #   data = super
  #   defaults = {id: "true", name: "true", description: "false", approved: "true", slug: "true", colors: "false", product_images: "false", product_sources: "true"}
  #   if params[:include_product_attributes]
  #     params[:include_product_attributes] = defaults.merge(params[:include_product_attributes])
  #   else
  #     params[:include_product_attributes] = defaults
  #   end
  #   data[:id] = object.id if params[:include_product_attributes][:id] == "true"
  #   data[:name] = object.name if params[:include_product_attributes][:name] == "true"
  #   data[:description] = object.description if params[:include_product_attributes][:description] == "true"
  #   data[:approved] = object.approved if params[:include_product_attributes][:approved] == "true"
  #   data[:slug] = object.slug if params[:include_product_attributes][:slug] == "true"
  #   data[:colors] = object.colors if params[:include_product_attributes][:colors] == "true"
  #   #The embedded associations currently point to the to_json versions of the associations rather than the serialized versions. There has to be some way to fix this...
  #   # data[:product_images] = object.product_images if params[:include_product_attributes][:product_images] == "true"
  #   # data[:product_sources] = object.product_sources if params[:include_product_attributes][:product_sources] == "true"
  #   # data
  # end

  # def embed_associations #something along these lines should eventually be used to create conditional embedding
  #   if params[:embed_associations][:product_images] == "object"
  #     has_many :product_images, embed: :objects
  #   elsif params[:embed_associations][:product_images] == "ids"
  #     has_many :product_images, embed: :ids
  #   else #covers nil case
  #   end

  #   if params[:embed_associations][:product_sources] == "object"
  #     has_many :product_sources, embed: :objects
  #   elsif params[:embed_associations][:product_sources] == "ids"
  #     has_many :product_sources, embed: :ids
  #   else #covers nil case
  #   end
  # end

end