# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  reviewer_id      :integer
#  review_item_id   :integer
#  review_item_type :string(255)
#

class Review < ActiveRecord::Base
  belongs_to :reviewer, class_name: "User"
  belongs_to :review_item, polymorphic: true
end
