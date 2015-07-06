ActiveAdmin.register Show do
  filter :flag
  filter :approved
  # filter :creator, as: :select, collection: proc {User.all.order(:id)}, input_html: {class: 'select2able', multiple: true}
  # filter :characters, as: :select, collection: proc {Character.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  # filter :episodes, as: :select, collection: proc {Episode.all.order(:name)}, input_html: {class: 'select2able', multiple: true} 
  # filter :network, as: :select, collection: proc {Network.all.order(:name)}, input_html: {class: 'select2able', multiple: true}

  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :characters, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'characters_id_in'}}
  filter :episodes, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/episodes/search', placeholder: 'Select Episodes', item: 'episodes_id_in'}}
  filter :network, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/networks/search', placeholder: 'Select Networks', item: 'network_id_in'}}

  filter :name
  filter :updated_at
  filter :created_at
  add_batch_actions(Show)

  menu :parent => "TV", :if => proc { current_user.fc_permissions? }


  scope :deleted
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :flagged


  controller do
    defaults finder: :find_by_slug

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # creator_id_in
      # characters_id_in
      # episodes_id_in
      # network_id_in
      unless params[:q].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
        params[:q][:characters_id_in] = params[:q][:characters_id_in][0].split(',') unless params[:q][:characters_id_in].blank?
        params[:q][:episodes_id_in] = params[:q][:episodes_id_in][0].split(',') unless params[:q][:episodes_id_in].blank?
        params[:q][:network_id_in] = params[:q][:network_id_in][0].split(',') unless params[:q][:network_id_in].blank?
      end
    end

    # def scoped_collection
    #     Show.unscoped
    # end

    def permitted_params
      params.permit!
    end

    def create
      convert_network
      convert_reviewers
      
      @show = Show.new(permitted_params[:show])
      @show.creator = current_user
      create!
    end

    def update
      convert_network
      convert_reviewers
      super
    end

    def convert_network
      # show[network]
      network_id = params[:show][:network]
      params[:show][:network] = network_id.present? ? Network.find_by_id(network_id.to_i) : nil
    end

    def convert_reviewers
      # To convert an array of String with reviewers' id into an array of User object
      reviewers_ids = params[:show][:reviewers]
      reviewers = []
      
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:show][:reviewers] = reviewers
    end

  end


  index do |shows|
    selectable_column
    column :flagged do |s|
      s.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :thumbnail do |s|
      content_tag(:div, image_tag(s.show_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :name
    column :slug
    column :approved do |s|
      s.approved ? '&#x2714;'.html_safe : ""
    end
    column :verified do |s|
      s.verified ? '&#x2714;'.html_safe : ""
    end
    actions
  end


  show do |s|
    panel "Review Info" do
      attributes_table_for s do
        row :flagged do |s|
          s.flag ? '&#x2714;'.html_safe : ""
        end
        row :verified do |s|
          s.verified ? '&#x2714;'.html_safe : ""
        end
        row :approved do |s|
          s.approved ? '&#x2714;'.html_safe : ""
        end
        row :creator
      end
    end

    panel "Show Info" do
      attributes_table_for s do
        row :id
        row :name
        row :slug
      end
    end

    panel "Images" do
      attributes_table_for s do
        s.show_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url)
          end
        end
      end
    end
    active_admin_comments
  end

  form html: {multipart: true} do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      # TODO
      # f.input :network, :as => :select, input_html: {class: 'select2able', placeholder: "Select Network"}
      f.input :network, :as => :hidden, value: f.object.network.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_networks_path, placeholder: "Select Network", label: 'Network', multiple: false, }}
    end

    f.has_many :show_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:square)) : nil)
      i.input :poster
      i.input :cover
    end

    f.has_many :characters, allow_destroy: true, heading: "Characters" do |c|
      c.input :name
      c.input :description
      c.input :actor
      c.input :gender, as: :select, collection: ["Male", "Female"]
      c.input :importance
      c.input :guest
      c.input :creator_id, :as => :hidden, :value => current_user.id

      c.has_many :character_images, allow_destroy: true, heading: "Images" do |j|
        j.input :avatar, :as => :file, :hint => (j.object.id ? image_tag(j.object.avatar.url(:square)) : nil)
        j.input :thumbnail
        j.input :cover
      end
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
    shows = Show.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: shows.as_json, total: Show.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    show = Show.find_by_id(params[:id].to_i)
    render json: {record: show.as_json}
  end
end
