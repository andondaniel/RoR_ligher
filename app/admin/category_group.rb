ActiveAdmin.register CategoryGroup do
  menu :parent => "Products", :if => proc { current_user.dm_permissions? }

  filter :name
  filter :gender

  controller do
    # def index
    #   index! do |format|
    #     format.html {render layout:'active_admin_by_filter'}
    #   end
    # end

    # before_filter :convert_filter_params, :only => :index

    # def convert_filter_params
    #   unless params[:q].blank?
    #     params[:q][:products_id_in] = params[:q][:products_id_in][0].split(',') unless params[:q][:products_id_in].blank?
    #   end
    # end
    def create
      # To convert select2 parameters into Active Admin friendly parameters
      convert_product_categories
      super
    end

    def update
      # To convert select2 parameters into Active Admin friendly parameters
      convert_product_categories
      super
    end

    def convert_product_categories
      # product[product_categories]
      product_categories_ids = params[:category_group][:product_categories]
      unless product_categories_ids.blank?
        product_categories = []
        product_categories_ids.split(',').each do |product_category_id|
          product_categories << ProductCategory.find_by_id(product_category_id.to_i) unless product_category_id.blank?
        end
        params[:category_group][:product_categories] = product_categories
      else
        params[:category_group][:product_categories] = []
      end
    end

    def permitted_params
      params.permit!
    end
  end

  index do |pc|
    column :id
    column :name
    column :gender
    column :product_categories do |cg|
      raw(cg.product_categories.map{ |x| "#{x.gender}: #{x.name}"}.join("<br>"))
    end
    actions
  end

  show do |p|
    panel "Product Info" do
      attributes_table_for p do
        row :name
        row :product_categories do |cg|
          raw(cg.product_categories.map{ |x| "#{x.gender}: #{x.name}" }.join("<br>"))
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
      f.input :product_categories, :as => :hidden, value: f.object.product_categories.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_product_categories_path, placeholder: "Select Product Categories", label: 'Product Categories', multiple: true}}, hint: "Multiple product categories can be selected"
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    category_groups = CategoryGroup.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: category_groups.as_json, total: CategoryGroup.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    category_groups = CategoryGroup.find_by_id(params[:id].to_i)
    render json: {record: category_groups.as_json}
  end
end