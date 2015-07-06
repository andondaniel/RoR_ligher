class AddResultHeaderToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :result_header, :string
  end
end
