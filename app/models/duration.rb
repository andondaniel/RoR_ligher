# == Schema Information
#
# Table name: durations
#
#  id         :integer          not null, primary key
#  start_time :integer
#  end_time   :integer
#  scene_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  verified   :boolean
#

class Duration < ActiveRecord::Base
  belongs_to :scene
  # belongs_to :episode
  # belongs_to :movie
  after_save :update_verification

  validates_presence_of :start_time
  validates_presence_of :end_time

  def update_verification
    if false # (start_time >= 0 ) && (episode ? (end_time <= episode.air_length) : true) && (movie ? (end_time <= movie.air_length) : true) #&& makes sure there is no overlap in durations for a given episode/movie
      update_column(:verified, true)
    else
      update_column(:verified, false)
    end
    return true
  end
end
