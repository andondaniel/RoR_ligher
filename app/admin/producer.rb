ActiveAdmin.register Producer do
  menu :parent => "Movies", :if => proc { current_user.fc_permissions? }


  # filter :movies, as: :select, collection: proc {Movie.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  filter :movies, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/movies/search', placeholder: 'Select Movies', item: 'movies_id_in'}}

  filter :name
  filter :created_at
  filter :updated_at

  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # movies_id_in
      unless params[:q].blank?
        params[:q][:movies_id_in] = params[:q][:movies_id_in][0].split(',') unless params[:q][:movies_id_in].blank?
      end
    end
    def permitted_params
      params.permit!
    end
  end

  show do |p|
    panel "Producer Info" do
      attributes_table_for p do
        row :name
        row "Movies", sortable: :slug do |p|
          p.movies.map { |m| m.name }.join(", ")
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    producers = Producer.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: producers.as_json, total: Producer.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    producer = Producer.find_by_id(params[:id].to_i)
    render json: {record: producer.as_json}
  end

end
