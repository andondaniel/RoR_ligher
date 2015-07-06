ActiveAdmin.register Product do
  filter :flag
  filter :verified
  filter :approved

  filter :characters, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'outfits_character_id_in'}}
  filter :brand, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/brands/search', placeholder: 'Select Brands', item: 'brand_id_in'}}
  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :product_categories, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/product_categories/search', placeholder: 'Select Product Cateogries', item: 'product_categories_id_in'}}
  filter :colors, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/colors/search', placeholder: 'Select Colors', item: 'colors_id_in'}}

  filter :created_at
  filter :updated_at
  filter :name
  filter :description
  filter :slug

  menu :parent => "Products", :if => proc { current_user.fc_permissions? }


  add_batch_actions(Product)
  add_admin_image_flags(Product)

  controller do
    defaults finder: :find_by_slug

    before_filter :convert_filter_params, :only => :index

    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes(:product_images, :shows, :episodes, :characters, :colors, :product_categories).includes(:creator => [:profile])
    end

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    def create
      # To convert select2 parameters into Active Admin friendly parameters
      convert_brand
      convert_colors
      convert_product_categories
      convert_store
      convert_reviewers
      
      @product = Product.new(permitted_params[:product])
      @product.creator = current_user
      create!
    end

    def update
      # To convert select2 parameters into Active Admin friendly parameters
      convert_brand
      convert_colors
      convert_product_categories
      convert_store
      convert_reviewers
      super
    end

    def convert_filter_params
      unless params[:q].blank?
        params[:q][:outfits_character_id_in] = params[:q][:outfits_character_id_in][0].split(',') unless params[:q][:outfits_character_id_in].blank?
        params[:q][:brand_id_in] = params[:q][:brand_id_in][0].split(',') unless params[:q][:brand_id_in].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
        params[:q][:product_categories_id_in] = params[:q][:product_categories_id_in][0].split(',') unless params[:q][:product_categories_id_in].blank?
        params[:q][:colors_id_in] = params[:q][:colors_id_in][0].split(',') unless params[:q][:colors_id_in].blank?
      end
    end

    def convert_brand
      # product[brand]
      brand_id = params[:product][:brand]
      unless brand_id.blank?
        params[:product][:brand] = Brand.find_by_id(brand_id.to_i)
      else
        params[:product][:brand] = nil
      end
    end

    def convert_colors
      # product[colors]
      colors_ids = params[:product][:colors]
      unless colors_ids.blank?
        colors = []
        colors_ids.split(',').each do |color_id|
          colors << Color.find_by_id(color_id.to_i) unless color_id.blank?
        end
        params[:product][:colors] = colors
      else
        params[:product][:colors] = []
      end
    end

    def convert_product_categories
      # product[product_categories]
      product_categories_ids = params[:product][:product_categories]
      unless product_categories_ids.blank?
        product_categories = []
        product_categories_ids.split(',').each do |product_category_id|
          product_categories << ProductCategory.find_by_id(product_category_id.to_i) unless product_category_id.blank?
        end
        params[:product][:product_categories] = product_categories
      else
        params[:product][:product_categories] = []
      end
    end

    def convert_store
      # product[product_sources_attributes][0][store]
      product_sources_attributes = params[:product][:product_sources_attributes]
      unless product_sources_attributes.blank?
        product_sources_attributes.each do |k, v|
          v[:store] = v[:store].present? ? Store.find_by_id(v[:store].to_i) : nil 
        end
      end
    end

    def convert_reviewers
      # To convert an array of String with reviewers' id into an array of User object
      reviewers_ids = params[:product][:reviewers]
      reviewers = []
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:product][:reviewers] = reviewers
    end

  end

  scope :deleted
  scope :verified_and_unapproved
  scope :verified_unapproved_and_unflagged
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :active
  scope :flagged

  index do |products|
    selectable_column
    column :flagged do |p|
      p.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image_count do |p|
      p.product_images.count
    end
    column :image do |p|
      content_tag(:div, image_tag(p.product_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column "Product Name", sortable: :name do |p|
      link_to p.name, admin_product_path(p)
    end
    # column :description, sortable: false
    column "Shows", sortable: 'shows.name' do |p|
      raw(p.shows.map { |show| show.name }.uniq.join("<br>"))
    end
    column "Characters", sortable: 'characters.name' do |p|
      raw(p.characters.map { |character| character.name }.uniq.join("<br>"))
    end
    column "Episodes", sortable: 'episodes.slug' do |p|
      raw(p.episodes.map { |episode| episode.slug }.uniq.join("<br>"))
    end
    column "Latest Comment" do |p|
      p.active_admin_comments.last.body if p.active_admin_comments.last
    end
    column :creator
    column :verified do |p|
      p.verified ? '&#x2714;'.html_safe : "" #raw(p.missing_verifications.join("<br>"))
    end
    column :approved do |p|
      p.approved ? '&#x2714;'.html_safe : ""
    end
    column :description
    column "Colors" do |p|
      raw(p.colors.map(&:name).uniq.join("<br>"))
    end
    column "Categories" do |p|
      raw(p.product_categories.map(&:name).uniq.join("<br>"))
    end
    column "Source information" do |p|
      if p.product_sources.any?
        ps = p.product_sources.first
        stock = ps.in_stock ? '&#x2714;'.html_safe : "None"
        available = ps.available ? '&#x2714;'.html_safe : "Nope"
        store = ps.store ? ps.store.name : "None"
        price = ps.price ? ps.price.format : "Error"
        raw(["<a href=#{ps.url}> URL: link </a>","Store: #{store}", "Price: #{price}", "Stock: #{stock}", "Available: #{available}"].join("<br>"))
      else
        "No product sources"
      end
    end

    actions

  end

  show do |p|

    product = p

    if p.outfits.select{|x| x.outfit_images.any?}.any?
      render partial: 'pin', locals: {p: product}
    end

    panel "Review Info" do
      attributes_table_for p do
        row :flagged do |p|
          p.flag ? '&#x2714;'.html_safe : ""
        end
        row :missing_verifications do |p|
          "" #raw(p.missing_verifications.join("<br>"))
        end
        row :approved do |p|
          p.approved ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |p|
          p.reviewers.map(&:name).join(", ")
        end
        row :creator
      end
    end

    panel "Product Info" do
      attributes_table_for p do
        row :name
        row :description
        row :brand
        row "Product Categories" do |p|
          p.product_categories.map { |product_category| product_category.to_s }.join("\n")
        end
        row :slug
      end
    end

    panel "Show Info" do
      attributes_table_for p do
        row "Shows", sortable: :name do |p|
          p.shows.map { |show| show.name }.join("\n")
        end
        row "Characters", sortable: :name do |p|
          p.characters.map { |character| character.name }.join("\n")
        end
        row "Episodes", sortable: :slug do |p|
          p.episodes.map { |episode| episode.slug }.join("\n")
        end
      end
    end

    panel "Images" do
      attributes_table_for p do
        p.product_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url) rescue "Image Not Found"
          end
        end
      end
    end

    panel "Sources" do
      p.product_sources.each_with_index do |source, index|
        attributes_table_for source do
          row :store do |s|
            s.store.name rescue ""
          end
          row :url
          row :in_stock
          row :available
          row :status
          row :price do |s|
            humanized_money_with_symbol s.price
          end
        end
      end
    end

    active_admin_comments

  end

  form html: {multipart: true} do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Brand" do
      # TODO
      # f.input :brand, as: :select, input_html: {class: 'select2able', placeholder: "Select a Brand"}, hint: "If the brand is not listed, click the new brand button below to create your brand in a new tab. Once you submit the brand form refresh this page and the new brand should appear. Make sure to refresh page before entering any other data."
      f.input :brand, :as => :hidden, value: f.object.brand.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_brands_path, placeholder: "Select a Brand", label: 'Brand', multiple: false}}, hint: "If the brand is not listed, click the new brand button below to create your brand in a new tab. Once you submit the brand form refresh this page and the new brand should appear. Make sure to refresh page before entering any other data."
    end

    f.inputs do
      link_to "New Brand", new_admin_brand_path, target: "_blank"
    end

    f.inputs do
      f.input :name, label: "Product Name"
      f.input :description
      # TODO
      # f.input :colors, :as => :select, input_html: {class: 'select2able', placeholder: "Select Colors"}, hint: "Multiple colors can be selected"
      # f.input :product_categories, :as => :select, input_html: {class: 'select2able', placeholder: "Select Categories"}, hint: "Multiple categories can be selected"
      f.input :colors, :as => :hidden, value: f.object.colors.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_colors_path, placeholder: "Select Colors", label: 'Colors', multiple: true}}, hint: "Multiple colors can be selected"
      f.input :product_categories, :as => :hidden, value: f.object.product_categories.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_product_categories_path, placeholder: "Select Product Categories", label: 'Product Categories', multiple: true}}, hint: "Multiple product categories can be selected"
    end


    f.has_many :product_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:square)) : nil)
      i.input :primary
    end

    f.has_many :product_sources, allow_destroy: true, heading: "Sources" do |s|
      # TODO
      # s.input :store, as: :select, input_html: {class: 'select2able', placeholder: "Select a Store"}
      s.input :store, :as => :hidden, value: s.object.store.try(&:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_stores_path, placeholder: "Select A Store", label: 'Store', multiple: false}}
      s.input :url, as: :string, label: "Link (URL)"
      s.input :new_price_value, as: :string, input_html: {value: s.object.price}, hint: "if price is unavailable enter $0.01"
      s.input :new_price_currency, as: :select, collection: currency_select_list, selected: s.object.price_currency.to_sym
      # s.input :status, as: :select, collection: [s.object.status, "valid", "invalid"]
      s.input :in_stock, hint: "uncheck if product is temporarily out of stock"
      s.input :available, hint: "uncheck if product is no longer carried by retailer"
    end

    f.inputs "Review" do
      # TODO
      # f.input :reviewers, :as => :select, input_html: {class: 'select2able', placeholder: "Select Reviewers"}, hint: "Multiple reviewers can be selected"
      f.input :reviewers, :as => :hidden, value: f.object.reviewers.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_users_path, placeholder: "Select Reviewers", label: 'Reviewers', multiple: true}}, hint: "Multiple reviewers can be selected"
      f.input :approved
      f.input :flag
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    products = Product.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: products.as_json, total: Product.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    product = Product.find_by_id(params[:id].to_i)
    render json: {record: product.as_json}
  end

end