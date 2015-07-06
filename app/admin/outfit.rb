ActiveAdmin.register Outfit do
  menu :parent => "Products", :if => proc { current_user.fc_permissions? }

  filter :flag
  filter :verified
  filter :approved


  filter :show, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: false, data:{source: '/admin/shows/search', placeholder: 'Select A Show', item: 'character_show_id_eq'}}
  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'outfit_products_product_id_in'}}
  filter :scenes, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/scenes/search', placeholder: 'Select Scenes', item: 'scenes_id_in'}}
  filter :episodes, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/episodes/search', placeholder: 'Select Episodes', item: 'scenes_episode_id_in'}}
  filter :character, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'character_id_in'}}
  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}

  filter :created_at
  filter :updated_at
  add_batch_actions(Outfit)
  add_admin_image_flags(Outfit)

  

  controller do
    def index
      index! do |format|
        @outfits.uniq! #something is fucked up in the filter for episodes (seems like every outfit is shown once for each scene it is in)
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # character_show_id_eq
      # outfit_products_product_id_in
      # scenes_id_in
      # scenes_episode_id_in
      # character_id_in
      # creator_id_in
      unless params[:q].blank?
        params[:q][:outfit_products_product_id_in] = params[:q][:outfit_products_product_id_in][0].split(',') unless params[:q][:outfit_products_product_id_in].blank?
        params[:q][:scenes_id_in] = params[:q][:scenes_id_in][0].split(',') unless params[:q][:scenes_id_in].blank?
        params[:q][:scenes_episode_id_in] = params[:q][:scenes_episode_id_in][0].split(',') unless params[:q][:scenes_episode_id_in].blank?
        params[:q][:character_id_in] = params[:q][:character_id_in][0].split(',') unless params[:q][:character_id_in].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
      end
    end
    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes([:outfit_images, :creator, :products, :character])
    end

    def new
      super
      @current_user = current_user
    end

    def create
      # To convert select2 ajax parameters into Active Admin friendly parameters
      convert_character
      convert_scenes
      convert_brand
      convert_colors
      convert_product_categories
      convert_store
      convert_reviewers
      convert_existing_products_exact
      convert_existing_products_non_exact
      
      @outfit = Outfit.new(permitted_params[:outfit])
      @outfit.creator = current_user
      create!
    end

    def update
      # To convert select2 ajax parameters into Active Admin friendly parameters
      convert_character
      convert_scenes
      convert_brand
      convert_colors
      convert_product_categories
      convert_store
      convert_reviewers
      convert_existing_products_exact
      convert_existing_products_non_exact
      super
    end

    def convert_character
      # outfit[character]
      character_id = params[:outfit][:character]
      unless character_id.blank?
        params[:outfit][:character] = Character.find_by_id(character_id.to_i)
      else
        params[:outfit][:character] = nil #prevents type mismatch in the case where character id is blank
      end
    end


    def convert_scenes
      # outfit[scenes]
      scenes_ids = params[:outfit][:scenes]
      unless scenes_ids.blank?
        scenes = []
        scenes_ids.split(',').each do |id|
          scenes << Scene.find_by_id(id.to_i)
        end
        params[:outfit][:scenes] = scenes
      else
        params[:outfit][:scenes] = []
      end
    end

    def convert_brand
      # outfit[outfit_products_attributes][3][product_attributes][brand]
      outfit_products_attributes = params[:outfit][:outfit_products_attributes]
      unless outfit_products_attributes.blank?
        outfit_products_attributes.each do |k, v|
          brand_id = v[:product_attributes][:brand]
          unless brand_id.blank?
            v[:product_attributes][:brand] = Brand.find_by_id brand_id.to_i
          else
            unless v[:product_attributes][:id].present?
              v[:product_attributes][:brand] = nil
            end
          end
        end
      end
    end

    def convert_colors
      outfit_products_attributes = params[:outfit][:outfit_products_attributes]
      unless outfit_products_attributes.blank?
        outfit_products_attributes.each do |k, v|
          colors = []
          ids = v[:product_attributes][:colors]
          unless ids.blank? || v[:product_attributes][:id].present?
            ids.split(',').each do |id|
              colors << Color.find_by_id(id.to_i)
            end
            v[:product_attributes][:colors] = colors
          else
            unless v[:product_attributes][:id].present?
              v[:product_attributes][:colors] = []
            end
          end
        end
      end
    end

    def convert_product_categories
      # outfit[outfit_products_attributes][2][product_attributes][product_categories]
      outfit_products_attributes = params[:outfit][:outfit_products_attributes]
      unless outfit_products_attributes.blank?
        outfit_products_attributes.each do |k, v|
          product_categories = []
          ids = v[:product_attributes][:product_categories]
          unless ids.blank? || v[:product_attributes][:id].present?
            ids.split(',').each do |id|
              product_categories << ProductCategory.find_by_id(id.to_i)
            end
            v[:product_attributes][:product_categories] = product_categories
          else
            unless v[:product_attributes][:id].present?
              v[:product_attributes][:product_categories] = []
            end
          end
        end
      end
    end

    def convert_store
      # outfit[outfit_products_attributes][2][product_attributes][product_sources_attributes][1][store]
      outfit_products_attributes = params[:outfit][:outfit_products_attributes]
      unless outfit_products_attributes.blank?
        outfit_products_attributes.each do |k, v|
          product_attributes = v[:product_attributes][:product_sources_attributes]
          unless product_attributes.blank?
            product_attributes.each do |k1, v1|
              v1[:store] = v1[:store].present? ? Store.find_by_id(v1[:store].to_i) : nil
            end

          end
        end
      end
    end

    def convert_existing_products_exact
      products_exact = params[:outfit][:existing_products_exact]
      unless products_exact.blank?
        products_ids = []
        products_exact.split(',').each do |product_id|
          products_ids << product_id unless product_id.blank?
        end
        params[:outfit][:existing_products_exact] = products_ids
      else
        params[:outfit][:existing_products_exact] = []
      end
    end

    def convert_existing_products_non_exact
      # outfit[existing_products_non_exact][]
      products_non_exact = params[:outfit][:existing_products_non_exact]
      unless products_non_exact.blank?
        products_ids = []
        products_non_exact.split(',').each do |product_id|
          products_ids << product_id unless product_id.blank?
        end
        params[:outfit][:existing_products_non_exact] = products_ids
      else
        params[:outfit][:existing_products_non_exact] = []
      end
    end

    def convert_reviewers
      reviewers_ids = params[:outfit][:reviewers]
      reviewers = []
      
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:outfit][:reviewers] = reviewers
    end

    # def show
    #   @outfit = Post.find(params[:id])
    #   @versions = @outfit.versions 
    #   @outfit = @outfit.versions[params[:version].to_i].reify if params[:version]
    #   show! #it seems to need this
    # end
  end
  
  # sidebar :versionate, :partial => "layouts/version", :only => :show
  
  scope :verified_and_unapproved
  scope :verified_unapproved_and_unflagged
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :active
  scope :flagged
  scope :contains_exact_match


  index do |outfits|
    selectable_column
    column :flagged do |o|
      o.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image do |o|
      content_tag(:div, image_tag(o.outfit_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :products do |o|
      ul do
        o.products.each do |p|
          if p.exact_match?(o)
            li do
              link_to admin_product_path(p) do
                content_tag(:div, image_tag(p.product_images.first.avatar(:thumb), :style=>"width: 100%"), style: "border: 2px solid green") rescue "Image not found"
              end
            end
          else
            li do
              link_to admin_product_path(p) do
                content_tag(:div, image_tag(p.product_images.first.avatar(:thumb), :style=>"width: 100%")) rescue "Image not found"
              end
            end
          end
        end
      end
    end
    column "Latest Comment" do |p|
      p.active_admin_comments.last.body if p.active_admin_comments.last
    end
    column :creator
    column :verified do |o|
      o.verified ? '&#x2714;'.html_safe : raw(o.missing_verifications.join("<br>"))
    end
    column :approved do |o|
      o.approved ? '&#x2714;'.html_safe : ""
    end
    column :updated_at
    actions
  end

  show do |outfit|
    panel "Review Info" do
      attributes_table_for outfit do
        row :flagged do |o|
          o.flag ? '&#x2714;'.html_safe : ""
        end
        row :missing_verifications do |o|
          raw(o.missing_verifications.join("<br>"))
        end
        row :approved do |o|
          o.approved ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |o|
          o.reviewers.map(&:name).join(", ")
        end
        row :creator
      end
    end
    panel "Outfit Info" do
      attributes_table_for outfit do
        row :episodes do |o|
          o.episodes.map(&:slug).join(", ")
        end
        row :change do |o|
          o.change
        end
        row :character do |o|
          o.character ? o.character.name : "No character found"
        end
        row :products do
          ul do
            outfit.products.each do |p|
              li do
                link_to admin_product_path(p) do
                  prod_name = "#{p.name} #{p.exact_match?(outfit) ? '(exact)' : '(non-exact)'}"
                  if p.product_images.any?
                    content_tag(:div, content_tag(:div, image_tag(p.product_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden") + "#{prod_name}" + " ID: #{p.id}")
                  else
                    prod_name
                  end
                end
              end
            end
          end
        end
      end
    end

    panel "Images" do
      attributes_table_for outfit do
        outfit.outfit_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url)
          end
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      # TODO
      # f.input :character, as: :select, input_html: {class: 'select2able'}
      f.input :character, :as => :hidden, value: f.object.character.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_characters_path, placeholder: "Select Character", label: 'Character', multiple: false}}
      f.input :change
      f.input :description
      # TODO
      # f.input :scenes, as: :select, input_html: {class: 'select2able'}, collection: Scene.find(:all, :order => "slug ASC")
      f.input :scenes, :as => :hidden, value: f.object.scenes.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_scenes_path, placeholder: "Select Scenes", label: 'Scenes', multiple: true}}
      f.has_many :outfit_images, allow_destroy: true, heading: "Images" do |i|
        i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url) : nil)
      end
    end

    f.inputs "Add Existing Products" do
      # f.input :existing_products_non_exact, as: :select, input_html: {class: 'select2able', multiple: true}, collection: Product.all
      # f.input :existing_products_exact, as: :select, input_html: {class: 'select2able', multiple: true}, collection: Product.all
      f.input :existing_products_non_exact, :as => :hidden, input_html: {class: 'ajax_select2able', data: {source: search_admin_products_path, placeholder: '', label: 'Existing products non exact', multiple: true}}
      f.input :existing_products_exact, :as => :hidden, input_html: {class: 'ajax_select2able', data: {source: search_admin_products_path, placeholder: '', label: 'Existing products exact', multiple: true}}
    end

    f.has_many :outfit_products, allow_destroy: true, heading: "Add New Products" do |op|
      current_product = op.object.product || Product.new
      op.inputs for: [:product, current_product], outfit: f.object, name: (current_product.new_record? ? "New Product" : "Existing Product") do |p|
        if current_product.new_record?
          # TODO
          # p.input :brand, as: :select, input_html: {class: 'select2able', placeholder: "Select a Brand"}, hint: "If the brand is not listed, click the new brand button below to create your brand in a new tab. Once you submit the brand form refresh this page and the new brand should appear. Make sure to refresh page before entering any other data."
          p.input :brand, :as => :hidden, value: p.object.brand.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_brands_path, placeholder: "Select a Brand", label: 'Brand', multiple: false, padding: true}}
          p.inputs do
            link_to "New Brand", new_admin_brand_path, target: "_blank"
          end
          p.input :creator_id, :as => :hidden, :value => current_user.id
          p.input :name, label: "Product Name"
          p.input :description
          p.input :approved
          # TODO
          # p.input :colors, :as => :select, input_html: {class: 'select2able', placeholder: "Select Colors"}, hint: "Multiple colors can be selected"
          # p.input :product_categories, :as => :select, input_html: {class: 'select2able', placeholder: "Select Categories"}, hint: "Multiple categories can be selected"
          p.input :colors, :as => :hidden, value: p.object.colors.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_colors_path, placeholder: "Select Colors", label: 'Colors', multiple: true, padding: true}}, hint: "Multiple colors can be selected"
          p.input :product_categories, :as => :hidden, value: p.object.product_categories.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_product_categories_path, placeholder: "Select Product Categories", label: 'Product Categories', multiple: true, padding: true}}, hint: "Multiple product categories can be selected"

          p.has_many :product_images, allow_destroy: true, heading: "Images" do |i|
            i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
            i.input :primary
          end

          p.has_many :product_sources, allow_destroy: true, heading: "Sources" do |s|
            # TODO
            # s.input :store, as: :select, input_html: {class: 'select2able', placeholder: "Select a Store"}
            s.input :store, :as => :hidden, value: s.object.store.try(&:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_stores_path, placeholder: "Select A Store", label: 'Store', multiple: false, padding: true}}
            s.input :url, as: :string, label: "Link (URL)"
            s.input :new_price_value, as: :string, input_html: {value: s.object.price}
            s.input :new_price_currency, as: :select, collection: currency_select_list, selected: s.object.price_currency.to_sym
            # s.input :status, as: :select, collection: [s.object.status, "Valid", "Invalid"]
            s.input :in_stock, hint: "uncheck if product is temporarily out of stock"
            s.input :available, hint: "uncheck if product is no longer carried by retailer"
          end
        else
          link_to admin_product_path(current_product), target: "_blank", class: 'outfit_existing_product' do
            prod_name = "#{current_product.name} #{current_product.exact_match?(outfit) ? '(exact)' : '(non-exact)'}"
            if current_product.product_images.any?
              "#{image_tag current_product.product_images.first.avatar(:thumb)} <br/> #{prod_name}".html_safe
            else
              prod_name
            end
          end
        end
      end
      op.input :exact_match
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
    outfits = Outfit.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: outfits.as_json, total: Outfit.finder(params[:q]).count}
  end


  collection_action :search_by, :method => :get do
    # TODO
    outfit = Outfit.find_by_id(params[:id].to_i)
    render json: {record: outfit.as_json}
  end
end