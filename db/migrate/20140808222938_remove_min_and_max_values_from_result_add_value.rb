class RemoveMinAndMaxValuesFromResultAddValue < ActiveRecord::Migration
  def change
  	remove_column :results, :min_value
  	remove_column :results, :max_value
  	add_column :results, :value, :integer
  end
end
