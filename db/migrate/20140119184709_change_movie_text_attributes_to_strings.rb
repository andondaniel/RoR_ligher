class ChangeMovieTextAttributesToStrings < ActiveRecord::Migration
  def self.up
   change_column :movies, :name, :string
   change_column :movies, :producer, :string
   change_column :movies, :director, :string
   change_column :movies, :tagline, :string
  end

  def self.down
   change_column :movies, :name, :text
   change_column :movies, :producer, :text
   change_column :movies, :director, :text
   change_column :movies, :tagline, :text
  end
end