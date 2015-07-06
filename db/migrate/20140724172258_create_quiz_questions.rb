class CreateQuizQuestions < ActiveRecord::Migration
  def change
    create_table :quiz_questions do |t|
      t.string :text
      t.references :quiz, index: true

      t.timestamps
    end
  end
end
