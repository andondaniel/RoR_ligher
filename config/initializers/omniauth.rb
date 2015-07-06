app_config = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
facebook_config = app_config["facebook"]

Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.env.production?
    provider :facebook, facebook_config["app_id"], facebook_config["app_serect"]
  else
    provider :facebook, facebook_config["app_id"], facebook_config["app_serect"]
  end

end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?

