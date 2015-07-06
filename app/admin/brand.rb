ActiveAdmin.register Brand do
  menu :parent => "Products", :if => proc { current_user.fc_permissions? }

  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
  filter :name
  filter :created_at
  filter :updated_at
  filter :slug

  controller do
    defaults finder: :find_by_slug

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    def permitted_params
      params.permit!
    end

    def create
      @brand = Brand.new(permitted_params[:brand])
      @brand.creator = current_user
      create!
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      unless params[:q].blank?
        params[:q][:products_id_in] = params[:q][:products_id_in][0].split(',') unless params[:q][:products_id_in].blank?
      end
    end
  end

  show do |c|
    panel "Brand Info" do
      attributes_table_for c do
        row :name
        row :slug
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
    brands = Brand.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: brands.as_json, total: Brand.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    brand = Brand.find_by_id(params[:id].to_i)
    render json: {record: brand.as_json}
  end

end
