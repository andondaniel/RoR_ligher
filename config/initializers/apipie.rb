Apipie.configure do |config|
  config.app_name                = "Spylight"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v*/*.rb"
  config.validate = false #allows slugs to be entered in urls rather than ids
  config.app_info = "Spylight RESTful API - See individual resource pages for information on :slug formatting guidelines"
  config.authenticate = Proc.new do
     authenticate_or_request_with_http_basic do |username, password|
       username == "test" && password == "supersecretpassword"
    end
  end
end
