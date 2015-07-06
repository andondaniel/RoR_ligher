class AddReviewableToNetworks < ActiveRecord::Migration
  def change
  	    add_column :networks, :creator_id, :integer, references: :users
  	    add_column :networks, :approved, :boolean, default: false
  	    add_column :networks, :verified, :boolean, default: false
  end
end
