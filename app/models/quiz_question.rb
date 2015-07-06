# == Schema Information
#
# Table name: quiz_questions
#
#  id         :integer          not null, primary key
#  text       :string(255)
#  quiz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class QuizQuestion < ActiveRecord::Base

	belongs_to :quiz
	has_many :options, :dependent => :delete_all

	accepts_nested_attributes_for :options, allow_destroy: true
end
