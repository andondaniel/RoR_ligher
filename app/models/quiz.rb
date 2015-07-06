# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  creator_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Quiz < ActiveRecord::Base
	include Reviewable

	has_many :quiz_questions, :dependent => :delete_all 
	has_many :results, :dependent => :delete_all 
	has_one :quiz_image

	has_many :quiz_takes

  accepts_nested_attributes_for :quiz_image, allow_destroy: true
	accepts_nested_attributes_for :quiz_questions, allow_destroy: true
	accepts_nested_attributes_for :results, allow_destroy: true
	
end
