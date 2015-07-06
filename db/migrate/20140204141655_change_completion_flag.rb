class ChangeCompletionFlag < ActiveRecord::Migration
  def change
  	change_table(:episodes) do |t|
  		t.remove :completed
  		t.column :fc_completed, :boolean
  		t.column :as_completed, :boolean
  	end
  end
end
