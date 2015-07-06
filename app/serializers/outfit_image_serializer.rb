class OutfitImageSerializer < ActiveModel::Serializer::ImageSerializer
  attributes :id, :urls, :avatar_file_name
end
