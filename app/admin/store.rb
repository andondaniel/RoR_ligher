ActiveAdmin.register Store do
  filter :name
  filter :updated_at
  filter :created_at
  menu :parent => "Products", :if => proc { current_user.fc_permissions? }

	controller do

		defaults finder: :find_by_slug

    def permitted_params
      params.permit!
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs :name

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
