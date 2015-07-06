if Rails.env.production? or Rails.env.development?
  Paperclip::Attachment.default_options[:url] = ':s3_alias_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:s3_host_name] = 's3.amazonaws.com'
  Paperclip::Attachment.default_options[:s3_host_alias] = 'static.spylight.com'

  Paperclip.interpolates :product_name do |attachment, style|
    attachment.instance.product.slug
  end
end