# == Schema Information
#
# Table name: active_admin_comments
#
#  id            :integer          not null, primary key
#  namespace     :string(255)
#  body          :text
#  resource_id   :string(255)      not null
#  resource_type :string(255)      not null
#  author_id     :integer
#  author_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class ActiveAdminComment < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :author, class_name: "User"
  belongs_to :resource_creator, class_name: "User"
  after_save :update_resource_creator


  def update_resource_creator
  	if resource
  		if resource.creator
  			update_column(:resource_creator_id, resource.creator.id)
  		end
  	end
  end
end
