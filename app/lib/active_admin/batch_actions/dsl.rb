module ActiveAdmin
  module BatchActions
    module DSL
      
      def add_fashion_consultant_actions(klass)
        admin_url = "admin_#{klass.to_s.underscore.pluralize.downcase}".to_sym

        batch_action :mark_as_paid do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(paid: true)
          end
          redirect_to admin_url
        end

        # batch_action :mark_as_completed do |selection|
        #   klass.find(selection).each do |k|
        #     k.update_attributes(completed: true)
        #   end
        #   redirect_to admin_url
        # end
      end



      def add_batch_actions(klass)
        admin_url = "admin_#{klass.to_s.underscore.pluralize.downcase}".to_sym

        batch_action :flag do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(flag: true)
          end
          redirect_to admin_url
        end

        batch_action :unflag do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(flag: false)
          end
          redirect_to admin_url
        end

        batch_action :approve do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(approved: true)
          end
          redirect_to admin_url
        end

        batch_action :unapprove do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(approved: false)
          end
          redirect_to admin_url
        end

        batch_action :unflag_and_approve do |selection|
          klass.find(selection).each do |k|
            k.update_attributes(approved: true, flag: false)
          end
          redirect_to admin_url
        end
      end

      def add_admin_image_flags(klass)
        admin_url = "admin_#{klass.to_s.underscore.pluralize.downcase}".to_sym

        batch_action :actor_uncentered do |selection|
          klass.find(selection).each do |resource|
            resource.update_attributes(flag: true)
            ActiveAdmin::Comment.create(namespace: "admin", body: "Actor is uncentered.", resource: resource, author: current_user)
          end
          redirect_to admin_url
        end

        batch_action :low_res do |selection|
          klass.find(selection).each do |resource|
            resource.update_attributes(flag: true)
            ActiveAdmin::Comment.create(namespace: "admin", body: "Image resolution is too low.", resource: resource, author: current_user)
          end
          redirect_to admin_url
        end

        batch_action :more_body do |selection|
          klass.find(selection).each do |resource|
            resource.update_attributes(flag: true)
            ActiveAdmin::Comment.create(namespace: "admin", body: "The image needs to show more of the actor's body", resource: resource, author: current_user)
          end
          redirect_to admin_url
        end

        batch_action :wrong_proportions do |selection|
          klass.find(selection).each do |resource|
            resource.update_attributes(flag: true)
            ActiveAdmin::Comment.create(namespace: "admin", body: "The image proportions are incorrect.", resource: resource, author: current_user)
          end
          redirect_to admin_url
        end

      end

    end
  end
end








