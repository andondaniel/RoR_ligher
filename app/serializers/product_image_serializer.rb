class ProductImageSerializer < ActiveModel::Serializer::ImageSerializer
  attributes :id, :urls, :avatar_file_name, :product_id
end