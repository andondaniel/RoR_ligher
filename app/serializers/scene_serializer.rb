class SceneSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :mobile_thumb_image_url, :mobile_full_image_url
  has_many :scene_images
  has_many :outfits, embed: :ids
end