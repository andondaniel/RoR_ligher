class CreateMovieImages < ActiveRecord::Migration
  def change
    create_table :movie_images do |t|

      t.timestamps
    end
  end
end
