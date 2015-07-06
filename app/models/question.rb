# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  text        :string(255)
#  answered    :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  creator_id  :integer
#

class Question < ActiveRecord::Base
	belongs_to :creator, class_name: "User"

	scope :answered,    -> { where(answered: true) }
	scope :unanswered,    -> { where(answered: false) }


end
