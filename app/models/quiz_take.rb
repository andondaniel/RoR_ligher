class QuizTake < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  belongs_to :result

  validates_presence_of :user
  validates_presence_of :quiz

  after_save :update_quiz_questions
  after_save :calculate_result

  def calculate_result
  	if (quiz_question_ids.count == answer_ids.count) && (quiz_question_ids.count != 0)
  		#result = calculated result
  		# update_column(:result_id, result.id)
  	end
  end

  def update_quiz_questions
  	ids = quiz.quiz_questions.map(&:id)
  	update_column(:quiz_question_ids, ids)
  end
end
