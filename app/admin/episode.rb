ActiveAdmin.register Episode do
  menu :parent => "TV", :if => proc { current_user.fc_permissions? }


  filter :flag
  filter :verified
  filter :approved

  # filter :creator, as: :select, collection: proc {User.all.includes(:profile).order(:id)}, input_html: {class: 'select2able', multiple: true}
  # filter :show, as: :select, collection: proc {Show.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  # filter :characters, as: :select, collection: proc {Character.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  # filter :outfits, as: :select, collection: proc {Outfit.all.order(:id)}, input_html: {class: 'select2able', multiple: true}

  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :show, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/shows/search', placeholder: 'Select Shows', item: 'show_id_in'}}
  filter :characters, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'characters_id_in'}}
  filter :outfits, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/outfits/search', placeholder: 'Select Outfits', item: 'outfits_id_in'}}

  filter :name
  filter :created_at
  filter :updated_at
  filter :season
  filter :episode_number
  filter :airdate
  filter :slug
  add_batch_actions(Episode)
  add_admin_image_flags(Episode)
  add_fashion_consultant_actions(Episode)

  controller do
    defaults finder: :find_by_slug

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      unless params[:q].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
        params[:q][:show_id_in] = params[:q][:show_id_in][0].split(',') unless params[:q][:show_id_in].blank?
        params[:q][:characters_id_in] = params[:q][:characters_id_in][0].split(',') unless params[:q][:characters_id_in].blank?
        params[:q][:outfits_id_in] = params[:q][:outfits_id_in][0].split(',') unless params[:q][:outfits_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes([{:creator => :profile}, :show, :episode_images, {:scenes => [:scene_images, :durations]}])
    end

    def create
      convert_outfits
      convert_reviewers
      @episode = Episode.new(permitted_params[:episode])
      @episode.creator = current_user
      create!
    end

    def update
      convert_outfits
      convert_reviewers
      super
    end

    def convert_outfits
      # To convert an array of String with outfits' id into an array of Outfit object
      scenes_attributes = params[:episode][:scenes_attributes]
      unless scenes_attributes.blank?
        scenes_attributes.each do |key, value| 
          outfits = []
          outfits_str = value[:outfits]
          outfits_str.split(',').each do |outfit|
            outfits << Outfit.find_by_id(outfit.to_i) 
          end
          value[:outfits] = outfits
        end
      end
    end

    def convert_reviewers
      # To convert an array of String with reviewers' id into an array of User object
      reviewers_ids = params[:episode][:reviewers]
      reviewers = []
      
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:episode][:reviewers] = reviewers
    end

  end

  scope :deleted
  scope :verified_and_unapproved
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :active
  scope :has_aired
  scope :flagged
  scope :unpaid

  index do |episodes|
    selectable_column
    column :flagged do |c|
      c.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image_count do |e|
      e.episode_images.count
    end
    column :thumbnail do |e|
      content_tag(:div, image_tag(e.primary_image(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :show
    column :season
    column :episode_number
    column :name
    column :airdate
    column "Latest Comment" do |p|
      p.active_admin_comments.last.body if p.active_admin_comments.last
    end
    column :creator
    column :verified do |c|
      c.verified ? '&#x2714;'.html_safe : raw(c.missing_verifications.join("<br>"))
    end
    column :fashion_consultant_completed do |c|
      c.fc_completed ? '&#x2714;'.html_safe : ""
    end
    column :audio_sync_completed do |c|
      c.as_completed ? '&#x2714;'.html_safe : ""
    end
    column :approved do |c|
      c.approved ? '&#x2714;'.html_safe : ""
    end
    column :paid do |c|
      c.paid ? '&#x2714;'.html_safe : ""
    end
    actions
  end

  show do |e|
    panel "Review Info" do
      attributes_table_for e do
        row :flagged do |o|
          o.flag ? '&#x2714;'.html_safe : ""
        end
        row :missing_verifications do |o|
          raw(o.missing_verifications.join("<br>"))
        end
        row :approved do |o|
          o.approved ? '&#x2714;'.html_safe : ""
        end
        row :fashion_consultant_completed do |c|
          c.fc_completed ? '&#x2714;'.html_safe : ""
        end
        row :audio_sync_completed do |c|
          c.as_completed ? '&#x2714;'.html_safe : ""
        end
        row :paid do |c|
          c.paid ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |o|
          if o.reviewers.any?
            o.reviewers.map(&:name).join(", ")
          else
            "No Reviewers Found"
          end
        end
        row :creator
      end
    end

    panel "Episode Info" do
      attributes_table_for e do
        row :show
        row :season
        row :episode_number
        row :name
        row :airdate
        row :tagline
        row :approved_outfit_count do |e|
          e.outfits.verified.count
        end
        row :image_count do |e|
          e.episode_images.count
        end
      end
    end

    panel "Images" do
      attributes_table_for e do
        e.episode_images.each_with_index do |image, index|
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
      f.input :show
      f.input :season
      f.input :episode_number 
      f.input :name
      f.input :tagline
      f.input :airdate, start_year: 2000
    end

    f.has_many :episode_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
      i.input :primary
    end

    f.has_many :scenes, allow_destroy: true, heading: "Scenes" do |s|
      s.input :scene_number, hint: "Don't forget to account for the introductory sequence in your numbering"
      s.input :intro
      s.has_many :durations, allow_destroy: true do |d|
        d.input :start_time, hint: "Enter as whole number of seconds"
        d.input :end_time, hint: "Enter as whole number of seconds"
      end
      s.has_many :scene_images, allow_destroy: true do |i|
        i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:square)) : nil)
        i.input :primary
        i.input :cover
      end
      s.input :outfits, :as => :hidden,  value: s.object.outfits.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_outfits_path, placeholder: 'Select Outfits', label: 'Outfits', multiple: true} }, hint: "Multiple outfits can be selected"
    end

    f.inputs "Review" do
      # f.input :reviewers, :as => :select, input_html: {class: 'select2able', placeholder: "Select Reviewers"}, hint: "Multiple reviewers can be selected"
      f.input :reviewers, :as => :hidden, value: f.object.reviewers.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_users_path, placeholder: "Select Reviewers", label: 'Reviewers', multiple: true}}, hint: "Multiple reviewers can be selected"
      f.input :approved
      f.input :flag
      f.input :fc_completed, hint: "Mark as FC completed once all fashion consultant data has been entered and is ready to be reviewed approval", label: "Fashion Consultant Completed"
      f.input :as_completed, hint: "Mark as AS completed once all audio sync data has been entered and is ready to be reviewed approval", label: "Audio Sync Completed"
      f.input :paid
    end

    f.actions
  end

  collection_action :search, :method => :get do
      # TODO
      episodes = Episode.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
      render json: { records: episodes.as_json, total: Episode.finder(params[:q]).count}
    end

    collection_action :search_by, :method => :get do
      # TODO
      episode = Episode.find_by_id(params[:id].to_i)
      render json: {record: episode.as_json}
    end

end