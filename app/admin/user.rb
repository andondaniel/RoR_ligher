ActiveAdmin.register User do

  menu :parent => "Admin", :if => proc { current_user.fc_permissions? }

  scope :basic
  scope :fashion_consultant
  scope :data_manager
  scope :admin
  scope :super_admin

  filter :profile, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/users/profile_search', placeholder: 'Select Users', item: 'profile_id_in'}}
  filter :products, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/products/search', placeholder: 'Select Products', item: 'products_id_in'}}
  filter :shows, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/shows/search', placeholder: 'Select Shows', item: 'shows_id_in'}}
  filter :outfits, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/outfits/search', placeholder: 'Select Outfits', item: 'outfits_id_in'}}
  filter :characters, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/characters/search', placeholder: 'Select Characters', item: 'characters_id_in'}}
  filter :episodes, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/episodes/search', placeholder: 'Select Episodes', item: 'episodes_id_in'}}
  filter :brands, as: :select, collection: [], input_html: {class: 'filter_select2able', multiple: true, data:{source: '/admin/brands/search', placeholder: 'Select Brands', item: 'brands_id_in'}}

  filter :email
  filter :created_at
  filter :updated_at
  filter :role
  filter :admin
  
  controller do
    def index
      index! do |format|
        format.html {render layout:'active_admin_by_filter'}
      end
    end

    before_filter :convert_filter_params, :only => :index

    def convert_filter_params
      # profile_id_in
      # products_id_in
      # shows_id_in
      # outfits_id_in
      # characters_id_in
      # episodes_id_in
      # brands_id_in
      unless params[:q].blank?
        params[:q][:profile_id_in] = params[:q][:profile_id_in][0].split(',') unless params[:q][:profile_id_in].blank?
        params[:q][:products_id_in] = params[:q][:products_id_in][0].split(',') unless params[:q][:products_id_in].blank?
        params[:q][:shows_id_in] = params[:q][:shows_id_in][0].split(',') unless params[:q][:shows_id_in].blank?
        params[:q][:outfits_id_in] = params[:q][:outfits_id_in][0].split(',') unless params[:q][:outfits_id_in].blank?
        params[:q][:characters_id_in] = params[:q][:characters_id_in][0].split(',') unless params[:q][:characters_id_in].blank?
        params[:q][:episodes_id_in] = params[:q][:episodes_id_in][0].split(',') unless params[:q][:episodes_id_in].blank?
        params[:q][:brands_id_in] = params[:q][:brands_id_in][0].split(',') unless params[:q][:brands_id_in].blank?
      end
    end

    def permitted_params
      params.permit!
    end

  end

  index do |u|
    selectable_column
    column :id
    column :name do |u|
      u.profile ? u.name : "No name found"
    end
    column :email
    column :role
    actions
  end

  scope :admin do |u|
    User.admin
  end



  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Profile", for: [:profile, f.object.profile || f.object.build_profile] do |p|
      p.input :first_name
      p.input :last_name
    end

    f.inputs "Info" do
      f.input :email
        f.input :password
        f.input :password_confirmation
      if authorized?(:change_role, user)
        f.input :role, as: :select, collection: ["Basic", "Quality Control", "Fashion Consultant", "Data Manager", "Admin"]
      end
      f.input :admin
    end

    f.actions
  end

  show do |u|

    div class: "column-1" do
      panel "Latest User Activity", class: "user-activity" do
        div :class => "attributes_table table_tools" do
          table_for PaperTrail::Version.where(whodunnit: "#{u.id}").order('id desc').limit(20), class: "scrolling_table" do # Use PaperTrail::Version if this throws an error
            column "Item" do |v| 
              if v.object && v.item
                if v.item_type == "Show"
                  link_to "SHOW: #{v.item.name}", [:admin, v.item]
                else 
                  link_to v.item, [:admin, v.item]
                end
              else
                "No item found"
              end
            end
            column "Event" do |v|
              if v.changeset["fc_completed"] == ([false,true] || [nil,true]) && v.changeset["as_completed"] == ([false,true] || [nil,true])
                "Outfits & Audio Sync Completed"
              elsif v.changeset["fc_completed"] == ([false,true] || [nil,true])
                "Outfits Completed"
              elsif v.changeset["fc_completed"] == ([true,false] || [nil,false])
                "Outfits Completed Undo"
              elsif v.changeset["as_completed"] == ([false,true] || [nil,true])
                "Audio Synced"
              elsif v.changeset["as_completed"] == ([true,false] || [nil,false])
                "Audio Sync Undo"
              elsif v.changeset["approved"] == [(false||nil),true]
                "Approved"
              elsif v.changeset["approved"] == [(true||nil),false]
                "Unapproved"
              elsif v.changeset["flagged"] == [(false||nil),true]
                "Flagged"
              elsif v.changeset["flagged"] == [(true||nil),false]
                "Unflagged"
              else 
                v.changeset.keys.delete_if{|x| x=="updated_at"}.map{|x| x.humanize}.to_s
              end
            end
            column "Modified at" do |v| v.created_at.to_s :short end
          end
        end
      end

      panel "Latest Comments", class: "comments" do
        div :class => "attributes_table table_tools" do
          table_for u.resource_comments.where('body != ?', "fixed!").order("id desc").limit(20), class: "scrolling_table" do
            column "Type" do |c|
              c.resource_type
            end
            column "Resource" do |c|
              link_to c.resource do
               c.resource.slug
              end
            end
            column "Comment" do |c|
              c.body
            end
          end
        end
      end

      panel "Flagged Products", class: "flagged-products" do
        div :class => "attributes_table table_tools" do
          table_for u.products.where(flag: true).sort { |x,y| y.id <=> x.id}, class: "scrolling_table" do
            column "Product" do |p|
              link_to admin_product_path(p) do
                p.name
              end
            end
          end
        end
      end

      panel "Flagged Outfits", class: "flagged-outfits" do
        div :class => "attributes_table table_tools" do
          table_for u.outfits.where(flag: true).sort { |x,y| y.id <=> x.id}, class: "scrolling_table" do
            column "Outfit" do |o|
              link_to admin_outfit_path(o) do
                o.slug
              end
            end
          end
        end
      end
    end

    div class: "column-2" do
      panel "Seasons in Progress" do
        div :class => "attributes_table table_tools" do
          u.worked_shows.each do |show, seasons|
            seasons.each do |season, episodes|
              seasons.delete_if { |season, episodes| (episodes.select{ |episode| (episode.paid == false && episode.approved == false) }).empty? }
              unless seasons.empty?
                panel "#{show.name} Season #{season}" do
                  div do
                    "Season Unique Product Count: #{Episode.unique_season_products(show, season).count}"
                  end
                  div do 
                    "Season Exact Match Percentage: #{Episode.exact_match_percent(show, season)}%"
                  end
                  table_for episodes.sort_by{ |ep| ep.episode_number} do
                    column "Episode Number" do |e|
                      link_to admin_episode_path(e) do
                        "#{e.episode_number}"
                      end
                    end
                    column "Approved?" do |e|
                      e.approved ? '&#x2714;'.html_safe : "Not Approved"
                    end
                    column "Paid?" do |e|
                      e.paid ? '&#x2714;'.html_safe : "Not Paid"
                    end
                    column "Approved Products until minimum" do |e|
                      if e.air_length == 1 || e.air_length == nil
                        "Scenes must be entered for accurate product calculation"
                      elsif e.air_length < 1800 #half hour shows
                        ((40 - e.products.count) > 0)  ? (40 - e.products.count) : "Minimum met!"
                      else #hour long shows
                        ((80 - e.products.count) > 0)  ? (80 - e.products.count) : "Minimum met!"
                      end
                    end
                    column "Outfit Count" do |e|
                      e.outfits.count
                    end
                    column "Flagged Products" do |e|
                      ul do
                        e.products.where(flag: true).each do |p|
                          li do
                            link_to admin_product_path(p) do
                              "#{p.id}"
                            end
                          end
                        end
                      end
                    end
                    column "Flagged Outfits" do |e|
                      ul do
                        e.outfits.where(flag: true).each do |o|
                          li do
                            link_to admin_outfit_path(o) do
                              "#{o.id}"
                            end
                          end
                        end
                      end
                    end
                    column "Unapproved Products" do |e|
                      ul do
                        e.products.unapproved.each do |p|
                          li do
                            link_to admin_product_path(p) do
                              "#{p.id}"
                            end
                          end
                        end
                      end
                    end
                    column "Unapproved Outfits" do |e|
                      ul do
                        e.outfits.unapproved.each do |o|
                          li do
                            link_to admin_outfit_path(o) do
                              "#{o.id}"
                            end
                          end
                        end
                      end
                    end
                    column "Products Not in Sets" do |e|
                      ul do
                        e.products.select{ |p| p.product_set == nil }.each do |p|
                          li do
                            link_to admin_product_path(p) do
                              "#{p.id}"
                            end
                          end
                        end
                      end
                    end
                  end
                end
              else
                div do
                  "No Seasons in Progress"
                end
              end
            end
          end
        end
      end

      attributes_table do
        row :name do |u|
          u.profile ? u.name : "No name found"
        end
        row :email
        row :episode_totals do
          table do
            tr do
              th "Total Episodes Created"
              th "Total Episodes Approved"
              th "Episodes Approved Yet Unpaid"
              th "Episodes Paid"
            end
            tr do
              td u.episodes.count
              td u.episodes.select{ |e| e.approved }.count
              td u.episodes.select{ |e| (e.approved && e.paid == false) }.count
              td u.episodes.select{ |e| e.paid }.count
            end
          end
        end
        # row "Created Episodes (Unapproved/Unpaid)" do
        #   ul do
        #     u.episodes.keep_if{ |e| (e.approved == false && e.paid == false) }.each do |e|
        #       li do
        #         link_to admin_episode_path(e) do 
        #           "#{e.slug} --- #{e.outfits.length} Outfits --- #{e.products.length} Products"
        #         end
        #       end           
        #       table_for e.outfits do
        #         column "Outfit" do |o|
        #           link_to admin_outfit_path(o) do
        #             "Outfit #{o.id}"
        #           end
        #         end
        #         column "Approved?" do |o|
        #           o.approved ? '&#x2714;'.html_safe : "Not Approved"
        #         end
        #         column "Verified?" do |o|
        #           o.verified ? '&#x2714;'.html_safe : raw(o.missing_verifications.join("<br>"))
        #         end
        #         column "Flagged?" do |o| 
        #           o.flag ? '&#x2714;'.html_safe : "Not Flagged" 
        #         end
        #         column "Last Comment" do |o|
        #           o.active_admin_comments.last ? o.active_admin_comments.last.body : "No Comments found"
        #         end
        #         column "Unapproved products within outfit" do |o|
        #           ul do
        #             o.products.keep_if{ |p| p.approved == false }.each do |p|
        #               li do
        #                 link_to admin_product_path(p) do
        #                   p.slug
        #                 end
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #   end
        # end
        # row "Approved Episodes (ready to be paid)" do
        #   ul do
        #     total_owed = 0
        #     u.episodes.keep_if{ |e| ((e.approved == true) && (e.paid == false))}.each do |e|
        #       li do 
        #         pay_owed = e.products.length >= 40 ? ((e.products.length - 40) / 2) + 30 : 0
        #         total_owed += pay_owed
        #         link_to admin_episode_path(e) do
        #           "#{e.slug} --- #{e.outfits.length} Outfits --- #{e.products.length} Products --- pay owed: $#{pay_owed}"
        #         end
        #       end
        #     end
        #     li do
        #       "Total owed: $#{total_owed}"
        #     end
        #   end
        # end
        # row "Paid Episodes" do
        #   ul do
        #     u.episodes.keep_if{ |e| e.paid }.each do |e|
        #       li do 
        #         link_to admin_episode_path(e) do
        #           "#{e.slug} --- #{e.outfits.length} Outfits --- #{e.products.length} Products"
        #         end
        #       end
        #     end
        #   end
        # end
      end

      panel "Movies" do
        div :class => "attributes_table table_tools" do
          table_for u.movies.order('paid asc') do 
            column "Slug" do |m|
              link_to admin_movie_path(m) do
                m.slug
              end
            end
            column "Approved Outfits" do |m|
              m.outfits.approved.count
            end
            column "Approved Products" do |m|
              m.products.approved.count
            end
            column "Total Products" do |m|
              m.products.count
            end
            column "Airtime" do |m|
              m.air_length
            end
            column "Approved?" do |m|
              m.approved ? '&#x2714;'.html_safe : "Not Approved"
            end
            column "Paid?" do |m|
              m.paid ? '&#x2714;'.html_safe : "Not Paid"
            end
          end
        end
      end
    end

  end

  collection_action :search, :method => :get do
    # TODO
    profiles = Profile.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: profiles.as_json, total: Profile.finder(params[:q]).count}
  end

  collection_action :search_by, :method => :get do
    # TODO
    user = Profile.find_by_user_id(params[:id].to_i)
    render json: {record: user.as_json}
  end

  collection_action :profile_search, :method => :get do
    # TODO
    profiles = Profile.finder_with_offset(params[:q], params[:page].to_i, params[:page_limit].to_i)
    render json: { records: profiles.as_json(profile: true), total: Profile.finder(params[:q]).count}
  end

  collection_action :profile_search_by, :method => :get do
    # TODO
    profile = Profile.find_by_id(params[:id].to_i)
    render json: {record: profile.as_json(profile: true)}
  end

end