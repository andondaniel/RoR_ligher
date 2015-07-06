class ImageSerializer < ActiveModel::Serializer

  def urls
  	style_urls = Hash.new
		object.avatar.options[:styles].keys.each do |style|
			style_urls[style] = object.avatar.url(style)
		end
		return style_urls
  end
  
end
