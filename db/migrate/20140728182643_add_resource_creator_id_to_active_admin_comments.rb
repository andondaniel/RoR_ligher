class AddResourceCreatorIdToActiveAdminComments < ActiveRecord::Migration
  def change
  	add_column :active_admin_comments, :resource_creator_id, :integer, references: :users
  end
end
