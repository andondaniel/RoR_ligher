ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }, :if => proc { current_user.fc_permissions? }


  content :title => "Dashboard" do

    if current_user.fc_permissions?
      panel "Welcome", :id => "welcome" do  
        ul "Statistics" do
          li do "Product Total Count: #{Product.count}" end
          li do "Active Product Count: #{Product.active.count}" end
          li do "Outfit Total Count: #{Outfit.count}" end
          li do "Active Outfit Count: #{Outfit.active.count}" end
          li do "Show Total Count: #{Show.count}" end
          li do "Approved Show Count: #{Show.approved.count}" end
        end
        ul "Useful Links" do
          li do 
            link_to "Fashion Consultant Guidelines", "/fc_guidelines.pdf"
          end
          li do
            link_to "Image Size Validation Cheat Sheet", "/image_sizes.pdf"
          end
          li do
            link_to "wornontv.net", "http://www.wornontv.net"
          end
          li do
            link_to "getthis.tv", "http://www.getthis.tv"
          end
          li do
            link_to "pradux.com", "http://www.pradux.com"
          end
          li do
            link_to "whataretheywearing.com/tag/tv", "http://www.whataretheywearing.com/tag/tv"
          end
          li do
            link_to "onscreenstyle.com", "http://www.onscreenstyle.com"
          end
        end
      end

      
      # panel "Recently Updated Content", class: "recent-updates" do
      #   div :class => "attributes_table table_tools" do
      #     table_for PaperTrail::Version.includes(:item).order('id desc').limit(20).delete_if{|x| x.object == nil} do # Use PaperTrail::Version if this throws an error
      #       column "Item" do |v| 
      #         if v.object && v.item #handles case where object is nil. Not sure why that ever happens though
      #           if v.item_type == "Show"
      #             link_to "SHOW: #{v.item.name}", [:admin, v.item]
      #           else 
      #             link_to v.item, [:admin, v.item] rescue v.item
      #           end
      #         else
      #           "No item found"
      #         end
      #       end
      #       column "Event" do |v|
      #         if v.event == "update"
      #           if v.changeset["fc_completed"] == [false,true] && v.changeset["as_completed"] == [false,true]
      #             "Outfits & Audio Sync Completed"
      #           elsif v.changeset["fc_completed"] == [false,true] 
      #             "Outfits Completed"
      #           elsif v.changeset["fc_completed"] == [true,false]
      #             "Outfits Completed Undo"
      #           elsif (v.changeset["as_completed"] == [false,true]) || (v.changeset["as_completed"] == [nil,true])
      #             "Audio Synced"
      #           elsif v.changeset["as_completed"] == [true,false]
      #             "Audio Sync Undo"
      #           elsif v.changeset["approved"] == [false,true]
      #             "Approved"
      #           elsif v.changeset["approved"] == [true,false]
      #             "Unapproved"
      #           elsif v.changeset["flagged"] == [false,true]
      #             "Flagged"
      #           elsif v.changeset["flagged"] == [true,false]
      #             "Unflagged"
      #           else 
      #             changes = v.changeset.keys.delete_if{|x| x=="updated_at"}.map{|x| x.humanize}.to_s
      #           end
      #         else
      #           v.event.humanize
      #         end
      #       end
      #       column "Admin" do |v| 
      #         if v.whodunnit
      #           link_to User.find(v.whodunnit).name, admin_user_path(User.find(v.whodunnit)) 
      #         else "?"
      #         end
      #       end
      #       column "Modified at" do |v| v.created_at.to_s :short end
      #     end
      #   end
      # end

      panel "Seasons in Progress" do
          div :class => "attributes_table table_tools" do
            current_user.worked_shows.each do |show, seasons|
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

      div class: "dashboard-quick" do
        panel "Latest User Activity", class: "user-activity" do
          div :class => "attributes_table table_tools" do
            table_for PaperTrail::Version.where(whodunnit: "#{current_user.id}").order('id desc').limit(20), class: "scrolling_table" do # Use PaperTrail::Version if this throws an error
              column "Item" do |v| 
                if v.object && v.item
                  if v.item_type == "Show"
                    link_to v.item.name, [:admin, v.item]
                  else 
                    link_to v.item, [:admin, v.item] rescue v.item
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
            table_for current_user.resource_comments.where('body != ?', "fixed!").order("id desc").limit(20), class: "scrolling_table" do
              column "Type" do |c|
                c.resource_type
              end
              column "Resource" do |c|
                begin
                  link_to [:admin, c.resource] do
                    c.resource.slug
                  end
                rescue
                  "No Link Available"
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
            table_for current_user.products.where(flag: true).sort { |x,y| y.id <=> x.id}, class: "scrolling_table" do
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
            table_for current_user.outfits.where(flag: true).sort { |x,y| y.id <=> x.id}, class: "scrolling_table" do
              column "Outfit" do |o|
                link_to admin_outfit_path(o) do
                  o.slug
                end
              end
            end
          end
        end
      end
    end
            
  end # content
end
