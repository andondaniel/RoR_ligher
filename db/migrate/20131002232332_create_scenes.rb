class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.integer :start_time
      t.integer :end_time

      t.timestamps
    end
  end
end
