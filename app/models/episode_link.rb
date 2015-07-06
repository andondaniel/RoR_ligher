# == Schema Information
#
# Table name: episode_links
#
#  id         :integer          not null, primary key
#  url        :text
#  title      :string(255)
#  alt_text   :string(255)
#  episode_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class EpisodeLink < ActiveRecord::Base
  belongs_to :episode
end
