ActiveAdmin.register Color do

  menu :parent => "Products", :if => proc { current_user.fc_permissions? }
  filter :name
  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
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
      unless params[:q].blank?
        params[:q][:products_id_in] = params[:q][:products_id_in][0].split(',') unless params[:q][:products_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end
  end

  show do |c|
    panel "Color Info" do
      attributes_table_for c do
        row :name
        row :color_code
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :color_code
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    colors = Color.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: colors.as_json, total: Color.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    color = Color.find_by_id(params[:id].to_i)
    render json: {record: color.as_json}
  end

end
