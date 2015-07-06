ActiveAdmin.register PropCategory do
  menu :parent => "Props", :if => proc { current_user.dm_permissions? }

  filter :name
  filter :created_at
  filter :updated_at
  filter :gender
  controller do

    def permitted_params
      params.permit!
    end

  end

  index do |pc|
    column :id
    column :name
    column :prop_category_groups do |pc|
      raw(pc.prop_category_groups.map(&:name).join("<br>"))
    end
    actions
  end

  show do |p|
    panel "Product Info" do
      attributes_table_for p do
        row :name
      end
    end

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
    product_categories = PropCategory.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: product_categories.as_json, total: PropCategory.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    product_category = PropCategory.find_by_id(params[:id].to_i)
    render json: {record: product_category.as_json}
  end
end