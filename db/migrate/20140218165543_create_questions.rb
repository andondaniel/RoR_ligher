class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :description
      t.string :text
      t.boolean :answered

      t.timestamps
    end
  end
end
