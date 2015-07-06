# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(provider, uid)
    find_by(provider: provider, uid: uid)
  end

  def self.create_with_omniauth(provider, uid)
    create(uid: uid, provider: provider)
  end

  def self.assign_to_user(id, user)
    identity = find(id)
    identity.user = user
    identity.save
  end
end
