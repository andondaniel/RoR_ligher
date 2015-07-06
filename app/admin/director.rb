ActiveAdmin.register Director do
  menu :parent => "Movies", :if => proc { current_user.fc_permissions? }

  # filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
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

    def permitted_params
      params.permit!
    end

    before_filter :convert_filter_params, :only => :index
    
    def convert_filter_params
      unless params[:q].blank?
        params[:q][:movies_id_in] = params[:q][:movies_id_in][0].split(',') unless params[:q][:movies_id_in].blank?
      end
    end
  end

  show do |d|
    panel "Director Info" do
      attributes_table_for d do
        row :name
        row "Movies", sortable: :slug do |d|
          d.movies.map { |m| m.name }.join(", ")
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
    directors = Director.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: directors.as_json, total: Director.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    director = Director.find_by_id(params[:id].to_i)
    render json: {record: director.as_json}
  end

end
