class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :title
      t.integer :creator_id, references: :users

      t.timestamps
    end
  end
end
