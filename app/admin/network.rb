ActiveAdmin.register Network do
  menu :parent => "TV", :if => proc { current_user.fc_permissions? }

  scope :verified
  scope :approved

  filter :shows, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/shows/search', placeholder: 'Select Shows', item: 'shows_id_in'}}
  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :reviewers, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Reviewers', item: 'reviews_reviewer_id_in'}}

  filter :name
  filter :created_at
  filter :updated_at
  filter :approved
  filter :verified

  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # shows_id_in
      # creator_id_in
      # reviews_reviewer_id_in
      unless params[:q].blank?
        params[:q][:shows_id_in] = params[:q][:shows_id_in][0].split(',') unless params[:q][:shows_id_in].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
        params[:q][:reviews_reviewer_id_in] = params[:q][:reviews_reviewer_id_in][0].split(',') unless params[:q][:reviews_reviewer_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

    def create
      convert_creators
      super
    end

    def update
      convert_creators
      super
    end

    def convert_creators
      # network[creator]
      creator_id = params[:network][:creator]
      params[:network][:creator] = creator_id.present? ? User.find_by_id(creator_id.to_i) : nil
    end
  end

  index do |networks|
    selectable_column
    column :id
    column :name
    column :approved do |s|
      s.approved ? '&#x2714;'.html_safe : ""
    end
    column :verified do |s|
      s.verified ? '&#x2714;'.html_safe : ""
    end
    actions
  end

  form html: {multipart: true} do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Details' do
      f.input :creator, :as => :hidden, value: f.object.creator.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_users_path, placeholder: "Select Creator", label: 'Creator', multiple: false}}
      f.input :name, :required => true
      f.input :approved
      f.input :verified
    end  

    f.actions
  end


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  collection_action :search, :method => :get do
    # TODO
    networks = Network.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: networks.as_json, total: Network.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    network = Network.find_by_id(params[:id].to_i)
    render json: {record: network.as_json}
  end

end
