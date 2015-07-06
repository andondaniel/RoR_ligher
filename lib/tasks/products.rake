namespace :products do
  desc "Check product sources for validity"
  task :check_sources  => :environment do
    count = ProductSource.count
    hydra = Typhoeus::Hydra.hydra
    start = 0
    batch_size = 50

    while start < count

      requests = {}
      statuses = {}

      puts "#{Time.now.strftime("at %I:%M:%S%p")}"
      puts "Checking #{start} - #{start + batch_size} of #{count}"
      ProductSource.order("id ASC").offset(start).limit(batch_size).each do |ps|
        id = ps.id

        unless ps.url.empty?
          requests[id] = Typhoeus::Request.new(ps.url)
          hydra.queue requests[id]
          requests[id].on_complete do |response|
            if response.success?
              statuses[id] = "valid - (#{response.code})"
            elsif response.timed_out?
              statuses[id] = "invalid - timeout (#{response.code})"
            elsif response.code == 0
              statuses[id] = "invalid - unknown (#{response.code})"
            else
              statuses[id] = "invalid (#{response.code})"
            end
          end
        else
          statuses[id] = "invalid - no url"
        end
      end

      hydra.run
      statuses.each_pair do |id, status|
        ProductSource.find(id).update_attribute(:status, status)
      end
      start += batch_size
    end
  end
  

  desc "Create basic outfits for products that don't already belong to one"
  task :create_basic_outfits => :environment do
    # methods to help us traverse the old associations (before outfits were added)
    def old_character(product)
      return nil if product.character_id.nil?
      return Character.find(20) if product.character_id == 14
      Character.find(product.character_id)
    end

    def old_episodes(product)
      old_episode_ids = Product.joins("INNER JOIN episodes_products ON products.id = episodes_products.product_id").where(id: product.id).pluck(:product_id, :episode_id).map{|ep| ep[1]}
      puts old_episode_ids.inspect
      old_episodes = Episode.find(old_episode_ids)
    end

    products_without_outfits = Product.includes(:outfits).select{|p| p.outfits.empty?}

    products_without_outfits.each do |product|
      # for each product, create a new outfit and transfer the episode / character associations
      Outfit.create! do |o|
        o.products << product
        # find the old episodes
        scenes = []
        old_episodes(product).each do |e|
          # if the episode has a scene, use the first one for our outfit, otherwise, create a dummy scene
          scenes << (e.scenes.any? ? e.scenes.first : e.scenes.create(start_time: 0, end_time: 1))
        end
        o.scenes << scenes
        o.character = old_character(product)
      end
    end

    potential_character_issues = []
    Product.all.each do |p|
      potential_character_issues << p if (!old_character(p).in?(p.characters))
    end

    puts "Products with potential character issues"
    potential_character_issues.each do |p|
      puts "================================="
      puts "Product \##{p.id}: #{p.name}"
      puts "Old character: #{old_character(p).try(:name)}"
      puts "New characters: #{p.characters.map(&:name).join(',')}"
      puts "================================="
      puts ""
    end

    potential_episode_issues = []
    Product.all.each do |p|
      potential_episode_issues << p if (false.in?(old_episodes(p).map{|oe| oe.in?(p.episodes)}))
    end

    puts "Products with potential character issues"
    potential_character_issues.each do |p|
      puts "================================="
      puts "Product \##{p.id}: #{p.name}"
      puts "Old episodes: " +  old_episodes(p).map(&:slug).join("; ")
      puts "New episodes: " + p.episodes.map(&:slug).join("; ")
      puts "================================="
    end
  end

  desc "Soft-delete duplicate products"
  task :delete_duplicates => :environment do
    duplicate_sets = Product.all.group_by{|p| (p.product_categories.try(:first).try(:name) || "") +  " " + p.name }.select{|name, products| products.size > 1}

    prod_sets_with_outfits    = duplicate_sets.select{|name, prods| (prods.map{|p| p.outfits.any?}.include?(true))}
    prod_sets_without_outfits = duplicate_sets.select{|name, prods| !(prods.map{|p| p.outfits.any?}.include?(true))}

    num_deleted = 0

    prod_sets_with_outfits.each do |name, products|
      if products.select{|p| p.outfits.any?}.size == 1
        # select the product with the outfit, since it's likely the best
        outfit_prod = products.select{|p| p.outfits.any?}.first
        others = products.select{|p| p.outfits.blank?} # the rest

        others.each do |other|
          match = (outfit_prod.attributes.keys - ["id", "created_at", "updated_at", "slug", "verified"]).inject(true) { |memo, att| memo && (outfit_prod[att] == other[att]) }
          if match
            other.destroy
            num_deleted += 1
          end
        end
      else # there is more than one product in the set with an outfit
        # don't do anything yet
      end
    end

    prod_sets_without_outfits.each do |name, products|
      a = products.sort_by(&:id).first
      products.delete(a)
      products.each do |other|
        match = (a.attributes.keys - ["id", "created_at", "updated_at", "slug", "verified"]).inject(true) { |memo, att| memo && (a[att] == other[att]) }
        if match
          other.destroy
          num_deleted += 1
        end
      end
    end


    # Recalculate duplicates
    duplicate_sets = Product.all.group_by{|p| (p.product_categories.try(:first).try(:name) || "") +  " " + p.name }.select{|name, products| products.size > 1}
    # prod_sets_with_outfits    = duplicate_sets.select{|name, prods| (prods.map{|p| p.outfits.any?}.include?(true))}
    # prod_sets_without_outfits = duplicate_sets.select{|name, prods| !(prods.map{|p| p.outfits.any?}.include?(true))}

    puts "Deleted #{num_deleted} products"
    puts "press 'enter' to see list of remaining potential duplicates, which were not deleted because they are unconfirmed"
    STDIN.gets
    duplicate_sets.each do |name, products|
      puts "----------------------"
      products.each do |p|
        puts "#{p.id}\t#{p.brand.name rescue ""}\t#{p.name}"
      end
    end
  end
end