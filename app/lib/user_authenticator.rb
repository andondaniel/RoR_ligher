require 'securerandom'

class UserAuthenticator
  def self.authenticate_with_email?(email, password)
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      return true
    else
      return false
    end
  end

  def self.authenticate_or_create_with_omniauth(auth, current_user = nil)
    provider = auth['provider'].to_s
    uid = auth['uid'].to_s

    # Find an identity here
    identity = Identity.find_with_omniauth(provider, uid)

    if identity.nil?
      # If no identity was found, create a brand new one here
      identity = Identity.create_with_omniauth(provider, uid)
    end

    if current_user
      if identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        return {success: true, user: current_user, status: :existing_link}
      else
        # The identity is not associated with the current_user so lets
        # associate the identity
        identity.user = current_user
        identity.save!
        return {success: true, user: current_user, status: :new_link}

      end
    else
      if identity.user.present?
        # The identity we found had a user associated with it so let's
        # just log them in here
        return {success: true, user: identity.user, status: :existing_user}
      else
        # No user associated with the identity so we need to create a new one
        user_info = auth[:info].slice(:first_name,:last_name,:email)
        new_user = User.new_from_omniauth(user_info)
        new_user.password_confirmation = new_user.password = SecureRandom.hex
        new_user.save!

        identity.user = new_user
        identity.save!

        return {success: true, user: new_user, status: :new_user }
      end
    end

  end

end
