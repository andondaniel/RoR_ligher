class AddApprovalStatusToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :approval_status, :boolean
  end
end
