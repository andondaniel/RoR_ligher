class AddProducerAndDirectorToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :producer, :text
    add_column :movies, :director, :text
  end
end
