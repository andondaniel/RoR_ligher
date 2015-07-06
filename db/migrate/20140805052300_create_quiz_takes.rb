class CreateQuizTakes < ActiveRecord::Migration
  def change
    create_table :quiz_takes do |t|
      t.references :user, index: true
      t.references :quiz, index: true
      t.references :result, index: true
      t.integer :quiz_question_ids, array: true, default: []
      t.integer :answer_ids, array: true, default: []

      t.timestamps
    end
  end
end
