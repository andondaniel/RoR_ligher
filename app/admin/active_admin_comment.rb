ActiveAdmin.register ActiveAdmin::Comment do
	actions :index, :show, :delete
	menu :parent => "Admin", :if => proc { current_user.fc_permissions? }

  after_create do |comment|
    AdminMailer.comment_created(comment).deliver
  end

  index do |c|
    column :id
    column :author
    column :resource_type
    column :resource
    column :resource_creator do |c|
      if c.resource
      	if c.resource.creator
      		link_to admin_user_path(c.resource.creator) do
      			c.resource.creator.name
      		end
      	else
      		"No Creator Found"
      	end
      else
        "No Resource Found"
      end
    end
    column :body
    
    actions
  end

  show do |c|
  	panel "Comment Info" do
  		attributes_table_for c do
		  	row :id
		  	row :author
		  	row :resource_type
		  	row :resource
		  	row :resource_creator do |c|
		    	c.resource.creator ? c.resource.creator : "No Creator Found"
		    end
		    row :body
		  end
		end
  end


end