ActiveAdmin.register Scene do
  menu :parent => "TV", :if => proc { current_user.fc_permissions? }


  # filter :show, as: :select, collection: proc {Show.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  # filter :episode, as: :select, collection: proc {Episode.all.order(:name)}, input_html: {class: 'select2able', multiple: true}

  filter :show, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/shows/search', placeholder: 'Select Shows', item: 'episode_show_id_in'}}
  filter :episode, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/episodes/search', placeholder: 'Select Episodes', item: 'episode_id_in'}}
  filter :updated_at
  filter :created_at

  add_batch_actions(Scene)
  add_admin_image_flags(Scene)


  scope :deleted
  scope :verified
  scope :approved
  scope :unverified
  scope :unapproved
  scope :active
  scope :flagged

  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # episode_show_id_in
      # episode_id_in
      unless params[:q].blank?
        params[:q][:episode_show_id_in] = params[:q][:episode_show_id_in][0].split(',') unless params[:q][:episode_show_id_in].blank?
        params[:q][:episode_id_in] = params[:q][:episode_id_in][0].split(',') unless params[:q][:episode_id_in].blank?
      end
    end

    def convert_outfits
      # To convert an array of String with outfits' id into an array of Outfit object
      outfits_ids = params[:scene][:outfits] 
      outfits = []

      outfits_ids.split(',').each do |outfit|
        outfits << Outfit.find_by_id(outfit.to_i) 
      end
      params[:scene][:outfits] = outfits
    end

    def permitted_params
      params.permit!
    end

    def create
      convert_outfits
      @scene = Scene.new(permitted_params[:scene])
      @scene.creator = current_user
      create!
    end

    def update
      convert_outfits
      super
    end
  end

  index do |s|
    selectable_column
    column :id
    column :flagged do |s|
      s.flag ? '&#x2714;'.html_safe : ""
    end
    column :image do |s|
      content_tag(:div, image_tag(s.scene_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :outfit_count do |s|
      s.outfits.count
    end
    column :episode do |s|
      s.episode ? (link_to s.episode.slug, admin_episode_path(s.episode)) : "No Episode Found"
    end
    column :movie do |s|
      s.movie ? (link_to s.movie.slug, admin_movie_path(s.movie)) : "No Movie Found"
    end
    column :intro do |s|
      s.intro ? '&#x2714;'.html_safe : ""
    end
    column :scene_number
    column :durations do |s|
      raw(s.durations.map { |d| "Start: #{d.start_time} End:#{d.end_time}"}.join("<br>"))
    end
    column :creator
    column :verified do |s|
      s.verified ? '&#x2714;'.html_safe : ""
    end
    column :approved do |s|
      s.approved ? '&#x2714;'.html_safe : ""
    end
    actions
  end

  show do |s|
    panel "Scene Info" do
      attributes_table_for s do
        row :episode do |s|
          s.episode ? (link_to s.episode.slug, admin_episode_path(s.episode)) : "No Episode Found"
        end
        row :movie do |s|
          s.movie ? (link_to s.movie.slug, admin_movie_path(s.movie)) : "No Movie Found"
        end
        row :intro do |s|
          s.intro ? '&#x2714;'.html_safe : ""
        end
        row :scene_number
        row :durations do 
          raw(s.durations.map { |d| "Start: #{d.start_time} End:#{d.end_time}"}.join("<br>"))
        end
        row :flagged do |s|
          s.flag ? '&#x2714;'.html_safe : ""
        end
        row :verified do |s|
          s.verified ? '&#x2714;'.html_safe : ""
        end
        row :approved do |s|
          s.approved ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |s|
          if s.reviewers.any?
            s.reviewers.map(&:name).join(", ")
          else
            "No Reviewers Found"
          end
        end
        row :creator
      end
    end
    panel "Images" do
      attributes_table_for s do
        s.scene_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url)
          end
        end
      end
    end
    panel "Outfits" do
      attributes_table_for s do
        s.outfits.each_with_index do |outfit, index|
          row "Scene Outfit #{index+1}" do
            link_to admin_outfit_path(outfit) do
              if outfit.outfit_images.any?
              content_tag(:div, content_tag(:div, image_tag(outfit.outfit_images.first.avatar(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden") + "Outfit #{outfit.id}")
              else
                "Outfit #{outfit.id}"
              end
            end
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
      f.input :episode, :as => :select, input_html: {class: 'select2able', placeholder: "Select Episode"}
      f.input :movie, :as => :select, input_html: {class: 'select2able', placeholder: "Select Movie"}

      f.input :scene_number, hint: "Don't forget to account for the introductory sequence in your numbering"
      f.input :intro
      f.has_many :durations, allow_destroy: true do |d|
        d.input :start_time, hint: "Enter as whole number of seconds"
        d.input :end_time, hint: "Enter as whole number of seconds"
      end
      f.has_many :scene_images, allow_destroy: true do |i|
        i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
        i.input :primary
        i.input :cover
      end
      f.input :outfits, :as => :hidden,  value: f.object.outfits.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_outfits_path, placeholder: 'Select Outfits', label: 'Outfits', multiple: true} }, hint: "Multiple outfits can be selected"
    end

    f.actions
  end

  collection_action :search, :method => :get do
      # TODO
      scenes = Scene.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
      render json: { records: scenes.as_json, total: Scene.finder(params[:q]).count}
    end

    collection_action :search_by, :method => :get do
      # TODO
      scene = Scene.find_by_id(params[:id].to_i)
      render json: {record: scene.as_json}
    end
end