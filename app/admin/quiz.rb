ActiveAdmin.register Quiz do
  menu :parent => "Quizzes", :if => proc { current_user.fc_permissions? }

  add_batch_actions(Quiz)
  add_fashion_consultant_actions(Quiz)

	controller do
    def permitted_params
      params.permit!
    end
  end

  index do |quizzes|
    selectable_column
    column :flagged do |q|
      q.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :question_count do |q|
      q.quiz_questions.count
    end
    column :title
    column :creator
    column :verified do |q|
      q.verified ? '&#x2714;'.html_safe : ""
    end
    column :approved do |q|
      q.approved ? '&#x2714;'.html_safe : ""
    end
    column :paid do |q|
      q.paid ? '&#x2714;'.html_safe : ""
    end
    actions
  end

  show do |quiz|
    render :partial => '/quizzes/quiz', :quiz => quiz
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :title
      f.input :result_header
    end

    f.inputs "Quiz Image", for: [:quiz_image, f.object.quiz_image || QuizImage.new] do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar(:cover)) : nil)
    end

    f.has_many :quiz_questions, allow_destroy: true, heading: "Questions" do |q|
      q.input :text
      q.has_many :options, allow_destroy: true, heading: "Options" do |o|
        o.input :text
        o.input :value
        o.inputs "Option Image", for: [:option_image, o.object.option_image || OptionImage.new] do |i|
          i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:cover)) : nil)
        end
      end
    end

    f.has_many :results, allow_destroy: true, heading: "Results" do |r|
      r.input :title
      r.input :text
      r.input :url
      r.input :value
      r.inputs "Result Image", for: [:result_image, r.object.result_image || ResultImage.new] do |i|
        i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:cover)) : nil)
      end
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    stores = Store.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: stores.as_json, total: Store.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    store = Store.find_by_id(params[:id].to_i)
    render json: {record: store.as_json}
  end

end
