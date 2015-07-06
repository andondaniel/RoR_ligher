# == Schema Information
#
# Table name: options
#
#  id               :integer          not null, primary key
#  text             :string(255)
#  value            :integer
#  quiz_question_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Option < ActiveRecord::Base
	belongs_to :quiz_question

	has_one :option_image
  accepts_nested_attributes_for :option_image, allow_destroy: true
end
