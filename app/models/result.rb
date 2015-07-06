# == Schema Information
#
# Table name: results
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  text       :string(255)
#  title      :string(255)
#  quiz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Result < ActiveRecord::Base
	belongs_to :quiz

	has_one :result_image
  accepts_nested_attributes_for :result_image, allow_destroy: true
end
