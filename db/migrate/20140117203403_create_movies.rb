class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.text :name

      t.timestamps
    end
  end
end
