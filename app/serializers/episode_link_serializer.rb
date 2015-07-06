class EpisodeLinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :alt_text
end