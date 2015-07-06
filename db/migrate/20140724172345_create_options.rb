class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :text
      t.integer :value
      t.references :quiz_question, index: true

      t.timestamps
    end
  end
end
