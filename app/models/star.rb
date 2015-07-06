# == Schema Information
#
# Table name: stars
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  starable_id   :integer
#  starable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Star < ActiveRecord::Base
 	belongs_to :starable, :polymorphic => true
 	belongs_to :user

 	validates_inclusion_of :starable_type, :in => ["Product", "Outfit", "Show", "Character", "Movie", "Prop"]
end
