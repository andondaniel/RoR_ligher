  # app/models/admin_authorization.rb
  class AdminAuthorization < ActiveAdmin::AuthorizationAdapter

      def authorized?(action, subject = nil)
        case subject
        when normalized(User)
          # Superadmins can perform all user actions
          if user.role == "Superadmin" || user.role == "Admin"
            true
          else
            if action == :update || action == :destroy
              subject == user
            # If it's not an update or destroy, anyone can view it
            else
              true
            end
          end
        else
          true
        end
      end

  end