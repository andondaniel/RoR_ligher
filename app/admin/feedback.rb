ActiveAdmin.register Feedback do

  menu :parent => "Admin", :if => proc { current_user.fc_permissions? }

  scope :filed
  scope :closed
  scope :on_hold
  scope :rejected
  scope :open do |feedbacks|
    feedbacks.where(status: nil)
  end


  feedback_url = "admin_#{Feedback.to_s.underscore.pluralize.downcase}".to_sym

  batch_action :close do |selection|
    Feedback.find(selection).each do |f|
      f.update_attributes(status: "Closed")
    end
    redirect_to feedback_url
  end
  batch_action :file do |selection|
    Feedback.find(selection).each do |f|
      f.update_attributes(status: "Filed on Github")
    end
    redirect_to feedback_url
  end
  batch_action :reject do |selection|
    Feedback.find(selection).each do |f|
      f.update_attributes(status: "Rejected")
    end
    redirect_to feedback_url
  end
  batch_action :hold do |selection|
    Feedback.find(selection).each do |f|
      f.update_attributes(status: "On hold")
    end
    redirect_to feedback_url
  end


  controller do

    def permitted_params
      params.permit!
    end
  end


  index do |c|
    selectable_column
    column :id
    column :email
    column :category
    column :status
    column :content
    actions
  end

  show do |c|
    panel "Feedback Info" do
      attributes_table_for c do
        row :id
        row :email
        row :category
        row :status
        row :content
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :category,  collection: Feedback.feedback_categories
      f.input :status, collection: Feedback.status_options.delete_if { |status| status == nil }
      f.input :content
    end

    f.actions
  end

end


# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  content    :text
#  category   :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime