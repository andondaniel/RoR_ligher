ActiveAdmin.register Source do
  config.filters = false
  config.batch_actions = false
  menu :parent => "Products"

  scope :valid do |ps|
    ps.valid.order("id asc")
  end
  scope :invalid do |ps|
    ps.invalid.order("id asc")
  end
  scope :all do |ps|
    Source.all.order("id asc")
  end

  scope :unavailable, :if => proc { current_user.fc_permissions? }

  controller do


    def permitted_params
      params.permit!
    end

    def scoped_collection
      # prevents N+1 queries to your database
      resource_class.includes(:sourceable)
    end

  end

  index do |product_sources|
    column "Source URL" do |ps|
      form_for(ps, remote: true, method: :put) do |f| 
        a href: ps.url, class: "product_source_link", data_id: ps.id do
          ps.id
        end
        f.hidden_field :link_checked, :value => true
      end
    end
    # column "Link Last Checked - May take up to 15 minutes to update" do |ps|
    #   ps.link_last_checked.strftime( "%m/%d/%Y at %I:%M%p %Z")
    # end
    # column "Status" do |ps|
    #   ps.status
    # end
    column "Source Price" do |ps|
      div class: "index_forms" do
        form_for(ps, remote: true, method: :put) do |f|
          f.text_field :new_price_value, style: "width: 50px", value: ps.price
          f.select :new_price_currency, currency_select_list, selected: ps.price_currency.to_sym
        end
      end
    end
    column "In stock?" do |ps|
      div class: "index_forms" do
        form_for(ps, remote: true, method: :put) do |f|
          f.check_box :in_stock, value: ps.in_stock
        end
      end
    end
    column "Available?" do |ps|
      div class: "index_forms" do
        form_for(ps, remote: true, method: :put) do |f|
          f.check_box :available, value: ps.available
        end
      end
    end
    if current_user.fc_permissions?
      column "Product" do |ps|
        if ps.product
          link_to admin_product_path(ps.product) do
            ps.product.slug
          end
        else
          "No product found"
        end
      end
      column "Product Verified?" do |ps|
        if ps.product
          ps.product.verified ? '&#x2714;'.html_safe : ""
        else
          "No product found"
        end
      end
      column "Product Set" do |ps|
        if ps.product
          if ps.product.product_set
            link_to admin_product_set_path (ps.product.product_set) do
              "#{ps.product.product_set.id}"
            end
          else
            "No Product Set Found"
          end
        else
          "No product found"
        end
      end
      column "Outfits" do |ps|
        if ps.product
          ul do
            ps.product.outfits.each do |o|
              li do
                link_to edit_admin_outfit_path(o) do
                  if ps.product.exact_match?(o)
                    "Exact Match: #{o.id}"
                  else
                    "Close Match: #{o.id}"
                  end
                end
              end
            end
          end
        else
          "No product found"
        end
      end
    end
  end

  # show do |ps|
  #   kit = IMGKit.new('http://google.com', format: "jpg")
  #   file = kit.to_file(Rails.root + "public/#{ps.id}.jpg")
  #   attributes_table_for ps do
  #     row :img do |ps|
  #       image_tag Rails.root + "public/#{ps.id}.jpg"
  #     end
  #   end
  # end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :url
    end

    f.actions
  end

end
