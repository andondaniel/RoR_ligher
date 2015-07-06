ActiveAdmin.register Movie do
  menu :parent => "Movies", :if => proc { current_user.fc_permissions? }


  filter :flag
  filter :verified
  filter :approved

  # filter :creator, as: :select, collection: proc {User.all.order(:id)}, input_html: {class: 'select2able', multiple: true}
  # filter :characters, as: :select, collection: proc {Character.all.order(:name)}, input_html: {class: 'select2able', multiple: true}
  # filter :outfits, as: :select, collection: proc {Outfit.all.order(:id)}, input_html: {class: 'select2able', multiple: true}

  filter :creator, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/search', placeholder: 'Select Creators', item: 'creator_id_in'}}
  filter :characters, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'characters_id_in'}}
  filter :outfits, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/outfits/search', placeholder: 'Select Creators', item: 'outfits_id_in'}}

  filter :name
  filter :slug
  add_batch_actions(Movie)
  add_admin_image_flags(Movie)
  add_fashion_consultant_actions(Movie)

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
      # outfits_id_in
      unless params[:q].blank?
        params[:q][:creator_id_in] = params[:q][:creator_id_in][0].split(',') unless params[:q][:creator_id_in].blank?
        params[:q][:characters_id_in] = params[:q][:characters_id_in][0].split(',') unless params[:q][:characters_id_in].blank?
        params[:q][:outfits_id_in] = params[:q][:outfits_id_in][0].split(',') unless params[:q][:outfits_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes(:movie_images)
    end

    def create
      convert_directors
      convert_producers
      convert_reviewers
      
      @movie = Movie.new(permitted_params[:movie])
      @movie.creator = current_user
      create!
    end

    def update
      convert_directors
      convert_producers
      convert_reviewers
      super
    end

    def convert_directors
      directors_ids = params[:movie][:directors]
      directors = []

      directors_ids.split(',').each do |director_id|
        directors << Director.find_by_id(director_id.to_i)
      end
      params[:movie][:directors] = directors
    end

    def convert_producers
      producers_ids = params[:movie][:producers]
      producers = []

      producers_ids.split(',').each do |producer_id|
        producers << Producer.find_by_id(producer_id.to_i)
      end
      params[:movie][:producers] = producers
    end

    def convert_reviewers
      # To convert an array of String with reviewers' id into an array of User object
      reviewers_ids = params[:movie][:reviewers]
      reviewers = []
      
      reviewers_ids.split(',').each do |reviewer|
        reviewers << User.find_by_id(reviewer.to_i) 
      end
      params[:movie][:reviewers] = reviewers
    end

  end

  index do |movies|
    selectable_column
    column :flagged do |m|
      m.flag ? '&#x2714;'.html_safe : ""
    end
    column :id
    column :image_count do |m|
      m.movie_images.count
    end
    column :thumbnail do |m|
      content_tag(:div, image_tag(m.primary_image(:square), :style=> "width: 100%"), :style => "width: 300px; height: 300px; overflow: hidden" ) rescue "Image not found"
    end
    column :name
    column "Latest Comment" do |p|
      p.active_admin_comments.last.body if p.active_admin_comments.last
    end
    column :creator
    column "Directors", sortable: :name do |m|
      m.directors.map { |d| d.name }.join(", ")
    end
    column "Producers", sortable: :slug do |m|
      m.producers.map { |p| p.name }.join(", ")
    end
    column :release_date
    column :verified do |m|
      m.verified ? '&#x2714;'.html_safe : raw(m.missing_verifications.join("<br>"))
    end
    column :approved do |m|
      m.approved ? '&#x2714;'.html_safe : ""
    end
    column :completed do |c|
      c.completed ? '&#x2714;'.html_safe : ""
    end
    column :paid do |c|
      c.paid ? '&#x2714;'.html_safe : ""
    end
    actions
  end

  show do |movie|
    panel "Review Info" do
      attributes_table_for movie do
        row :flagged do |o|
          o.flag ? '&#x2714;'.html_safe : ""
        end
        row :missing_verifications do |o|
          raw(o.missing_verifications.join("<br>"))
        end
        row :approved do |o|
          o.approved ? '&#x2714;'.html_safe : ""
        end
        row :completed do |c|
          c.completed ? '&#x2714;'.html_safe : ""
        end
        row :paid do |c|
          c.paid ? '&#x2714;'.html_safe : ""
        end
        row :reviewers do |o|
          o.reviewers.map(&:name).join(", ")
        end
        row :creator
      end
    end

    panel "Movie Info" do
      attributes_table_for movie do
        row :name
        row "Directors", sortable: :name do |m|
          m.directors.map { |d| d.name }.join(", ")
        end
        row "Producers", sortable: :slug do |m|
          m.producers.map { |p| p.name }.join(", ")
        end
        row :release_date
        row :tagline
        row :approved_outfit_count do |m|
          m.outfits.verified.count
        end
        row :image_count do |m|
          m.movie_images.count
        end
      end
    end

    panel "Images" do
      attributes_table_for movie do
        movie.movie_images.each_with_index do |image, index|
          row "Image #{index+1} Raw" do
            image_tag(image.avatar.url)
          end
        end
      end
    end

    panel "Outfits" do
      div :class => "attributes_table table_tools" do
        table_for movie.outfits.order('approved asc').includes(:products) do 
          column "Slug" do |o|
            link_to admin_outfit_path(o) do
              o.slug
            end
          end
          column "Verrified?" do |o|
            o.verified ? '&#x2714;'.html_safe : "Not Verrified"
          end
          column "Approved?" do |o|
            o.approved ? '&#x2714;'.html_safe : "Not Approved"
          end
          column "Products" do |o|
            ul do
              o.products.each do |p|
                li do
                  link_to admin_product_path(p) do
                    "#{p.name} #{p.exact_match?(o) ? '(exact)' : '(non-exact)'}"
                  end
                end
              end
            end
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
      f.input :tagline
      f.input :release_date
      # TODO
      f.input :directors, :as => :hidden, value: f.object.directors.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_directors_path, placeholder: "Select Director", label: 'Directors', multiple: true}}, hint: "Multiple directors can be selected"
      f.input :producers, :as => :hidden, value: f.object.producers.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_producers_path, placeholder: "Select Producer", label: 'Producers', multiple: true}}, hint: "Multiple producers can be selected"
    end

    f.has_many :movie_images, allow_destroy: true, heading: "Images" do |i|
      i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
      i.input :poster
      i.input :cover
    end

    f.has_many :characters, allow_destroy: true, heading: "Characters" do |c|
      c.input :name
      c.input :description
      c.input :actor
      c.input :gender, as: :select, collection: ["Male", "Female"]
      c.input :importance

      c.has_many :character_images, allow_destroy: true, heading: "Images" do |i|
        i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
        i.input :thumbnail
        i.input :cover
      end
    end

    # f.has_many :scenes, allow_destroy: true, heading: "Scenes" do |s|
    #   s.input :scene_number, hint: "Don't forget to account for the introductory sequence in your numbering"
    #   s.input :intro
    #   s.has_many :durations, allow_destroy: true do |d|
    #     d.input :start_time, hint: "Enter as whole number of seconds"
    #     d.input :end_time, hint: "Enter as whole number of seconds"
    #   end
    #   s.has_many :scene_images, allow_destroy: true do |i|
    #     i.input :avatar, :as => :file, :hint => (i.object.id ? image_tag(i.object.avatar.url(:thumb)) : nil)
    #   end
    #   s.input :outfits, :as => :select, input_html: {class: 'select2able', placeholder: "Select Outfits"}, hint: "Multiple outfits can be selected"
    # end

    f.inputs "Review" do
      # TODO
      f.input :reviewers, :as => :hidden, value: f.object.reviewers.map(&:id).join(','), input_html: {class: 'ajax_select2able', data: {source: search_admin_users_path, placeholder: "Select Reviewers", label: 'Reviewers', multiple: true}}, hint: "Multiple reviewers can be selected"
      f.input :approved
      f.input :flag
      f.input :completed
      f.input :paid
    end

    f.actions
  end

  collection_action :search, :method => :get do
    # TODO
    movies = Movie.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: movies.as_json, total: Movie.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    movie = Movie.find_by_id(params[:id].to_i)
    render json: {record: movie.as_json}
  end

end
