class SceneImageSerializer < ActiveModel::Serializer::ImageSerializer
  attributes :id, :urls, :avatar_file_name, :scene_id
end