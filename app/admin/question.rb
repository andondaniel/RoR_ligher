ActiveAdmin.register Question do
  menu :parent => "Admin", :if => proc { current_user.fc_permissions? }

  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}

  filter :title
  filter :description
  filter :text
  filter :answered
  filter :created_at
  filter :updated_at

  after_create do |question|
    AdminMailer.question_asked(question).deliver
  end

  
  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # creator_id_in
      unless params[:q].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
      end
    end
    def permitted_params
      params.permit!
    end

    def create
      @question = Question.new(permitted_params[:question])
      @question.creator = current_user
      create!
    end
  end

  scope :answered
  scope :unanswered

  index do |questions|
    column :id
    column :creator
    column :title
    column :answered do |q|
      q.answered ? '&#x2714;'.html_safe : ""
    end
    actions
  end


  show do |q|
    panel "Question Info" do
      attributes_table_for q do
        row :title
        row :description
        row :creator
        row :answered do |q|
          q.answered ? '&#x2714;'.html_safe : ""
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :title, hint: "Short description of question"
      f.input :description, hint: "If longer description or more details are necessary please enter them here"
      f.input :answered, hint: "Please mark as answered once a satisfactory answer has been given in the comments"
    end

    f.actions
  end
  
end
