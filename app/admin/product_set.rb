ActiveAdmin.register ProductSet do
  menu :parent => "Products", :if => proc { current_user.fc_permissions? }


  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
  filter :created_at
  filter :updated_at
  filter :id
  add_batch_actions(ProductSet)



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

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes(:products)
    end

    def create
      # To convert select2 parameters into friendly Active Admin parameters
      convert_products
      convert_add_products
      params[:product_set][:last_updater_id] = current_user.id
      super
      
      # @product_set = ProductSet.new
      # @product_set.creator = current_user
      # create!
    end

    def update
      # To convert select2 parameters into friendly Active Admin parameters
      convert_products
      convert_add_products
      params[:product_set][:last_updater_id] = current_user.id
      super
    end

    def convert_products
      # product_set[product_ids][]
      products_ids = params[:product_set][:products]
      unless products_ids.blank?
        products_ids_new = []
        products_ids.split(',').each do |product_id|
          products_ids_new << Product.find_by_id(product_id.to_i) unless product_id.blank?
        end
        params[:product_set][:products] = products_ids_new
      else
        params[:product_set][:products] = []
      end
    end

    def convert_add_products
      # product_set[add_products][]
      products_ids = params[:product_set][:add_products]
      unless products_ids.blank?
        products_ids_new = []
        products_ids.split(',').each do |product_id|
          products_ids_new << product_id unless product_id.blank?
        end
        params[:product_set][:add_products] = products_ids_new
      else
        params[:product_set][:add_products] = []
      end
    end

  end


  scope :approved
  scope :unapproved
  scope :flagged


  index do |ps|
    selectable_column
    column :flagged do |ps|
      ps.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :products do |ps|
      table do
        tr do
          ps.products.each do |p|
            td do
              link_to admin_product_path(p) do
                content_tag(:div, image_tag(p.product_images.first.avatar(:thumb), :style=>"width: 100%"), :style => "width: 100px; height: 100px; display: inline-block; overflow: hidden") rescue "Image not found"
              end
            end
          end
        end
        tr do
          ps.products.each do |p|
            td do
              if p.price
                "#{p.price}"
              else
                "{p.name}"
              end
            end
          end
        end
      end
    end
    column :approved do |o|
      o.approved ? '&#x2714;'.html_safe : ""
    end
    column :last_updater
    actions
  end




  show do |ps|
    panel "Product Set Info" do
      attributes_table_for ps do
        row :id
        row :last_updater
        row :product_slugs do
          ps.products.map &:slug
        end
      end
    end

    panel "Products" do
      ps.products.each do |prod|
        attributes_table_for prod do
          row :name
          row :slug
        end

        attributes_table_for prod do
          prod.product_images.each_with_index do |image, index|
            row "Image #{index+1} Raw" do
              image_tag(image.avatar.url)
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Products" do
      # TODO
      # f.input :products, label: "View / Delete products already in set", as: :select, input_html: {class: 'select2able', placeholder: "Select Products", multiple: true}, hint: "Do not use this field to add additional products to this set. It may break things."
      # f.input :add_products, as: :select, input_html: {class: 'select2able', placeholder: "Select Products", multiple: true}, collection: Product.all, hint: "If you add a product that is already in a separate product set, its entire set will be combined with this one."
      f.input :products, :as => :hidden, value: f.object.products.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_products_path, placeholder: "Select Products", label: 'View / Delete products already in set', multiple: true}}, hint: 'Do not use this field to add additional products to this set. It may break things.'
      f.input :add_products, :as => :hidden, value: nil, input_html: {class: 'ajax_select2able', data: {source: search_admin_products_path, placeholder: "Select Products", label: 'Add products', multiple: true}}, hint: 'If you add a product that is already in a separate product set, its entire set will be combined with this one.'
    end

    f.actions
  end

end
