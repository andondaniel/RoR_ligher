class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.integer :start_time
      t.integer :end_time
      t.references :scene, index: true

      t.timestamps
    end
  end
end
