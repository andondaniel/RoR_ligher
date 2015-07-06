ActiveAdmin.register ProductCategory do
  menu :parent => "Products", :if => proc { current_user.dm_permissions? }

  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
  filter :category_groups, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/category_groups/search', placeholder: 'Select Category Groups', item: 'category_groups_id_in'}}
  filter :name
  filter :created_at
  filter :updated_at
  filter :gender
  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      unless params[:q].blank?
        params[:q][:category_groups_id_in] = params[:q][:category_groups_id_in][0].split(',') unless params[:q][:category_groups_id_in].blank?
        params[:q][:products_id_in] = params[:q][:products_id_in][0].split(',') unless params[:q][:products_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

    def create
      # To convert select2 parameters into Active Admin friendly parameters
      convert_category_groups
      super
    end

    def update
      # To convert select2 parameters into Active Admin friendly parameters
      convert_category_groups
      super
    end

    def convert_category_groups
      # product[product_categories]
      category_groups_ids = params[:product_category][:category_groups]
      unless category_groups_ids.blank?
        category_groups = []
        category_groups_ids.split(',').each do |category_group_id|
          category_groups << CategoryGroup.find_by_id(category_group_id.to_i) unless category_group_id.blank?
        end
        params[:product_category][:category_groups] = category_groups
      else
        params[:product_category][:category_groups] = []
      end
    end
  end

  index do |pc|
    column :id
    column :name
    column :gender
    column :category_groups do |pc|
      raw(pc.category_groups.map{ |x| "#{x.gender}: #{x.name}"}.join("<br>"))
    end
    actions
  end

  show do |p|
    panel "Product Info" do
      attributes_table_for p do
        row :name
        row :category_groups do |pc|
          raw(pc.category_groups.map{ |x| "#{x.gender}: #{x.name}"}.join("<br>"))
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :gender, as: :select, collection: ["Male", "Female", "Neutral"]
      f.input :category_groups, :as => :hidden, value: f.object.category_groups.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_category_groups_path, placeholder: "Select Category Groups", label: 'Category Groups', multiple: true}}, hint: "Multiple Category Groups can be selected"
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    product_categories = ProductCategory.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: product_categories.as_json, total: ProductCategory.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    product_category = ProductCategory.find_by_id(params[:id].to_i)
    render json: {record: product_category.as_json}
  end
end