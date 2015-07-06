# == Schema Information
#
# Table name: api_clients
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  app_token   :string(255)
#  valid       :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class APIClient < ActiveRecord::Base
end
