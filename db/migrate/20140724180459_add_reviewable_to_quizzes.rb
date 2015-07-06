class AddReviewableToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :approved, :boolean, default: false
    add_column :quizzes, :verified, :boolean, default: false
    add_column :quizzes, :flag, :boolean, default: false
    add_column :quizzes, :paid, :boolean, default: false
  end
end
