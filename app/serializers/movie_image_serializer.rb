class MovieImageSerializer < ActiveModel::Serializer::ImageSerializer
  attributes :id, :urls, :primary, :avatar_file_name
end