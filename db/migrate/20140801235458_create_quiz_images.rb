class CreateQuizImages < ActiveRecord::Migration
  def change
    create_table :quiz_images do |t|
      t.references :quiz, index: true
      t.text :url
      t.text :alt_text

      t.timestamps
    end
  end
end
