require 'csv'

def mongo_import(file, klass, storage_hash, attrs, associations={})
  CSV.foreach(Rails.root.join('db/mongo_export', file), headers: true) do |row|
    new_object = klass.create! do |obj|
      attrs.each do |attr|
        obj.send(attr+"=", row[attr])
      end
      associations.each do |assoc, source|
        obj.send(assoc+"=", assoc.classify.constantize.find(source[row[assoc]]))
      end
    end
    storage_hash[row['o_id']] = new_object.id
  end
end

shows = {}
stores = {}
brands = {}
colors = {}
characters = {}
episodes = {}
product_categories = {}
products = {}
stores = {}

# Show.destroy_all
# Store.destroy_all
# Brand.destroy_all
# Color.destroy_all
# Character.destroy_all
# Episode.destroy_all
# ProductCategory.destroy_all
# Product.destroy_all


mongo_import('shows.csv', Show, shows, ['name'])
mongo_import('stores.csv', Store, stores, ['name'])
mongo_import('brands.csv', Brand, brands, ['name'])
mongo_import('colors.csv', Color, colors, ['name'])
mongo_import('characters.csv', Character, characters, ['name'], {"show" => shows})
mongo_import('episodes.csv', Episode, episodes, ['season', 'episode_number'], {"show" => shows})
mongo_import('types.csv', ProductCategory, product_categories, ['name'])

CSV.foreach(Rails.root.join('db/mongo_export', 'products.csv'), headers: true) do |row|
  new_product = Product.create! do |prod|
      prod.name = row['name']
      prod.description = row['description']
      prod.brand = Brand.find(brands[row['brand']])
      prod.episodes <<  Episode.find(episodes[row['episode']])


      case characters[row['character']]
      when 19, 9
        prod.character = Character.find(11)
      when 18
        prod.character = Character.find(12)
      when 17, 15
        prod.character = Character.find(13)
      when 16
        prod.character = Character.find(6)
      else
        prod.character = Character.find(characters[row['character']])
      end

      unless row['type'].blank?
        prod.product_categories << ProductCategory.find(product_categories[row['type']])
      end

      unless row['color'].blank?
        case colors[row['color']]
        when 2
          prod.colors << Color.find(5)
        when 1
          prod.colors << Color.find(7)
        when 21
          prod.colors << Color.find(20)
        else
          prod.colors << Color.find(colors[row['color']])
        end
      end

      image_hash = JSON.parse(row['images'])
      image_hash.each_pair do |name, path|
        prod.product_images.build(avatar: File.new("/Users/alb64/Downloads/spylight-prod2/#{path}"))
      end

      new_ps = ProductSource.create! do |ps|
        ps.url = row['url']
        ps.price_cents = row['retail_price'].to_f * 100
        ps.store = Store.find(stores[row['store']])
      end
      prod.product_sources << new_ps
  end
end

Character.where(:id => [9,15,16,17,18,19]).destroy_all
Color.where(:id => [1,2,21]).destroy_all

users = { casper: {email: "casper@spylight.com", password: "spylight2013", password_confirmation: "spylight2013", admin: true, profile_attributes: {first_name: "Casper", last_name: "Daugaard"}},
          aly:   {email: "aly@spylight.com", password: "spylight2013", password_confirmation: "spylight2013", admin: true, profile_attributes: {first_name: "Aly", last_name: "Moore"}},
          april:   {email: "april@spylight.com", password: "spylight2013", password_confirmation: "spylight2013", admin: true, profile_attributes: {first_name: "April", last_name: "Koh"}},
          jacob:   {email: "jacob@spylight.com", password: "spylight2013", password_confirmation: "spylight2013", admin: true, profile_attributes: {first_name: "Jacob", last_name: "Williams"}},
          adam:   {email: "adam@spylight.com", password: "spylight2013", password_confirmation: "spylight2013", admin: true, profile_attributes: {first_name: "Adam", last_name: "Bray"}}
        }

users.each_value do |user|
  User.create(user)
end