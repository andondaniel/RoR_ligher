ActiveAdmin.register Prop do
  filter :flag
  filter :verified
  filter :approved

  filter :brand, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/brands/search', placeholder: 'Select Brands', item: 'brand_id_in'}}
  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}

  filter :created_at
  filter :updated_at
  filter :name
  filter :description
  filter :slug

  menu :parent => "Props", :if => proc { current_user.fc_permissions? }


  add_batch_actions(Prop)
  add_admin_image_flags(Prop)

  controller do

    before_filter :convert_filter_params, :only => :index

    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes(:prop_images, :shows, :episodes).includes(:creator => [:profile])
    end

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    def create
      # To convert select2 parameters into Active Admin friendly parameters
      convert_brand
      convert_store
      convert_scene
      convert_prop_categories
      @prop = Prop.new(permitted_params[:prop])
      @prop.creator = current_user
      create!
    end

    def update
      # To convert select2 parameters into Active Admin friendly parameters
      convert_brand
      convert_store
      convert_scene
      convert_prop_categories
      super
    end


    def convert_filter_params
      unless params[:q].blank?
        params[:q][:brand_id_in] = params[:q][:brand_id_in][0].split(',') unless params[:q][:brand_id_in].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
      end
    end


    def convert_brand
      # prop[brand]
      brand_id = params[:prop][:brand]
      unless brand_id.blank?
        params[:prop][:brand] = Brand.find_by_id(brand_id.to_i)
      else
        params[:prop][:brand] = nil
      end
    end

    def convert_store
      prop_sources_attributes = params[:prop][:prop_sources_attributes]
      unless prop_sources_attributes.blank?
        prop_sources_attributes.each do |k, v|
          v[:store] = v[:store].present? ? Store.find_by_id(v[:store].to_i) : nil 
        end
      end
    end

    def convert_scene
      prop_scenes_attributes = params[:prop][:prop_scenes_attributes]
      unless prop_scenes_attributes.blank?
        prop_scenes_attributes.each do |k, v|
          scene_id = v[:scene]
          unless scene_id.blank?
            v[:scene] = Scene.find_by_id scene_id.to_i
          else
            unless v[:id].present?
              v[:scene] = nil
            end
          end
        end
      end
    end

    def convert_prop_categories
      prop_categories_ids = params[:prop][:prop_categories]
      unless prop_categories_ids.blank?
        prop_categories = []
        prop_categories_ids.split(',').each do |prop_category_id|
          prop_categories << PropCategory.find_by_id(prop_category_id.to_i) unless prop_category_id.blank?
        end
        params[:prop][:prop_categories] = prop_categories
      else
        params[:prop][:prop_categories] = []
      end
    end

  end

  scope :verified_and_unapproved
  scope :verified_unapproved_and_unflagged
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :active
  scope :flagged

  index do |props|
    selectable_column
    column :flagged do |p|
      p.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image_count do |p|
      p.prop_images.count
    end
    column :image do |p|
      content_tag(:div, image_tag(p.prop_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column "Prop Name", sortable: :name do |p|
      link_to p.name, admin_prop_path(p)
    end
    column "Categories" do |p|
      raw(p.prop_categories.map(&:name).uniq.join("<br>"))
    end
    column "Shows", sortable: 'shows.name' do |p|
      raw(p.shows.map { |show| show.name }.uniq.join("<br>"))
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

    actions

  end

  show do |p|

    panel "Review Info" do
      attributes_table_for p do
        row :flagged do |p|
          p.flag ? '&#x2714;'.html_safe : ""
        end
        row :approved do |p|
          p.approved ? '&#x2714;'.html_safe : ""
        end
        row :creator
      end
    end

    panel "Prop Info" do
      attributes_table_for p do
        row :name
        row :description
        row :brand
        row :slug
        row "Prop Categories" do |p|
          p.prop_categories.map { |prop_category| prop_category.name }.join("\n")
        end
      end
    end

    panel "Show Info" do
      attributes_table_for p do
        row "Shows", sortable: :name do |p|
          p.shows.map { |show| show.name }.join("\n")
        end
        row "Episodes", sortable: :slug do |p|
          p.episodes.map { |episode| episode.slug }.join("\n")
        end
      end
    end

    panel "Images" do
      attributes_table_for p do
        p.prop_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url) rescue "Image Not Found"
          end
        end
      end
    end

    panel "Sources" do
      p.prop_sources.each_with_index do |source, index|
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
      f.input :name, label: "Prop Name"
      f.input :description
      f.input :prop_categories, :as => :hidden, value: f.object.prop_categories.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_prop_categories_path, placeholder: "Select Prop Categories", label: 'Prop Categories', multiple: true}}, hint: "Multiple product categories can be selected"
    end

    f.has_many :prop_scenes, allow_destroy: true, heading: "Appearances" do |ps|
      ps.input :scene, :as => :hidden, value: ps.object.scene.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_scenes_path, placeholder: "Select Scene", label: 'Scene', multiple: false}}
      ps.input :exact_match
    end


    f.has_many :prop_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:square)) : nil)
    end

    f.has_many :prop_sources, allow_destroy: true, heading: "Sources" do |s|
      s.input :store, :as => :hidden, value: s.object.store.try(&:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_stores_path, placeholder: "Select A Store", label: 'Store', multiple: false}}
      s.input :url, as: :string, label: "Link (URL)"
      s.input :new_price_value, as: :string, input_html: {value: s.object.price}, hint: "if price is unavailable enter $0.01"
      s.input :new_price_currency, as: :select, collection: currency_select_list, selected: s.object.price_currency.to_sym
      # s.input :status, as: :select, collection: [s.object.status, "valid", "invalid"]
      s.input :in_stock, hint: "uncheck if prop is temporarily out of stock"
      s.input :available, hint: "uncheck if prop is no longer carried by retailer"
    end

    f.inputs "Review" do
      # TODO
      f.input :approved
      f.input :flag
    end

    f.actions
  end


end