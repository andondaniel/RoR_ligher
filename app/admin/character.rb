ActiveAdmin.register Character do
  
  #  CHARACTERS can be found under "TV" in activeadmin
  menu :parent => "TV" , :if => proc { current_user.fc_permissions? }

  filter :flag
  filter :verified
  filter :approved

  # filter :creator, as: :select, collection: proc {User.all.order(:id)}, input_html: {class: 'select2able', multiple: true}
  # filter :show, as: :select, collection: proc {Show.all.order(:name)}, input_html: {class: 'select2able', multiple: true}

  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :show, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/shows/search', placeholder: 'Select Shows', item: 'show_id_in'}}
  filter :movie, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/movies/search', placeholder: 'Select Movies', item: 'movie_id_in'}}

  filter :name
  filter :created_at
  filter :updated_at
  filter :slug
  filter :actor
  filter :gender

  scope :verified_and_unapproved
  scope :flagged

  add_batch_actions(Character)
  add_admin_image_flags(Character)

  controller do
    defaults finder: :find_by_slug

    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # show_id_in
      # creator_id_in
      unless params[:q].blank?
        params[:q][:show_id_in] = params[:q][:show_id_in][0].split(',') unless params[:q][:show_id_in].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

    def create
      convert_show
      convert_movie
      convert_reviewers

      @character = Character.new(permitted_params[:character])
      @character.creator = current_user
      create!
    end

    def update
      convert_show
      convert_movie
      convert_reviewers

      super
    end

    def convert_show
      show_id = params[:character][:show]
      if show_id.blank?
        params[:character][:show] = nil
      else
        params[:character][:show] = Show.find_by_id(show_id.to_i)
      end
    end

    def convert_movie
      movie_id = params[:character][:movie]
      if movie_id.blank?
        params[:character][:movie] = nil
      else
        params[:character][:movie] = Movie.find_by_id(movie_id.to_i)
      end
    end

    def convert_reviewers
      # To convert an array of String with reviewers' id into an array of User object
      reviewers_ids = params[:character][:reviewers]
      reviewers = []
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:character][:reviewers] = reviewers
    end

  end

  index do |c|
    selectable_column
    column :flagged do |c|
      c.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image do |c|
      content_tag(:div, image_tag(c.thumbnail_image(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :name
    column :actor
    column :gender
    column :guest do |c|
      c.guest ? '&#x2714;'.html_safe : ""
    end
    column :verified do |c|
      c.verified ? '&#x2714;'.html_safe : raw(c.missing_verifications.join("<br>"))
    end
    column :approved do |c|
      c.approved ? '&#x2714;'.html_safe : ""
    end
    column :slug
    column :importance
    column :cover_photo do |c|
      c.character_images.cover.any? ? '&#x2714;'.html_safe : ""
    end
    column :thumbnail_photo do |c|
      c.character_images.thumbnail.any? ? '&#x2714;'.html_safe : ""
    end
    column :creator
    actions
  end

  show do |c|
    panel "Review Info" do
      attributes_table_for c do
        row :flagged do |o|
          o.approved ? '&#x2714;'.html_safe : ""
        end
        row :missing_verifications do |o|
          raw(o.missing_verifications.join("<br>"))
        end
        row :approved do |o|
          o.approved ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |o|
          o.reviewers.any? ? o.reviewers.map(&:name).join(", ") : "No reviewers"
        end
        row :creator
      end
    end

    panel "Character Info" do
      attributes_table_for c do
        row :name
        row :slug
        row :description
        row :gender
        row :guest
        row :actor
        row :importance
        row :cover_photo do |c|
          c.character_images.cover.any?
        end
        row :thumbnail_photo do |c|
          c.character_images.thumbnail.any?
        end
        if c.show
          row :show do |c|
            c.show.name
          end
        elsif c.movie
          row :movie do |c|
            c.movie.name
          end
        end
      end
    end

    panel "Images" do
      attributes_table_for c do
        c.character_images.each_with_index do |image, index|
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
      f.input :name
      # TODO
      # f.input :show, :as => :select, input_html: {class: 'select2able', placeholder: "Select Show"}
      # f.input :movie, :as => :select, input_html: {class: 'select2able', placeholder: "Select Movie"}
      f.input :show, :as => :hidden, value: f.object.show.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_shows_path, placeholder: "Select Show", label: 'Show', multiple: false}}
      f.input :movie, :as => :hidden, value: f.object.movie.try(:id), input_html: {class: 'ajax_select2able', data: {source: search_admin_movies_path, placeholder: "Select Movie", label: 'Movie', multiple: false}}
      f.input :description
      f.input :actor
      f.input :gender, as: :select, collection: ["Male", "Female"]
      f.input :guest
      f.input :importance
    end

    f.has_many :character_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
      i.input :thumbnail
      i.input :cover
    end

    f.inputs "Review" do
      # TODO
      f.input :reviewers, :as => :hidden, value: f.object.reviewers.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_users_path, placeholder: "Select Reviewers", label: 'Reviewers', multiple: true}}, hint: "Multiple reviewers can be selected"
      f.input :approved
      f.input :flag
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    characters = Character.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: characters.as_json, total: Character.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    character = Character.find_by_id(params[:id].to_i)
    render json: {record: character.as_json}
  end

end
