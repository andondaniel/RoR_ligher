# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  content    :text
#  category   :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feedback < ActiveRecord::Base
	@@status_options = ["Filed on Github", "Closed", "On Hold", "Rejected", nil]
	@@feedback_categories = ["Bug Report", "Suggestion", "Question", "Comment", "Other"]

	validates_inclusion_of :status, :in => @@status_options
	validates_inclusion_of :category, :in => @@feedback_categories

	scope :closed,    -> { where(status: "Closed") }
	scope :on_hold,   -> { where(status: "On Hold") }
	scope :rejected,  -> { where(status: "Rejected") }
	scope :filed,     -> { where(status: "Filed on Github") }
	scope :open, 			-> { where(status: nil ) }

	def self.status_options
		@@status_options
	end

	def self.feedback_categories
		@@feedback_categories
	end
end
