class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :url
      t.string :text
      t.string :title
      t.integer :min_value
      t.integer :max_value
      t.references :quiz, index: true

      t.timestamps
    end
  end
end
