class ChangeFeedbackTypeToFeedbackCategory < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :type, :category
  end
end
