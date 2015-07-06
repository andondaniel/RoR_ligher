desc "Recover lost character associations and merge duplicat characters/colors"
task :recovery_script  => :environment do 
  require 'csv'
  def mongo_import(file, storage_hash, key_attr, value_attr)
    CSV.foreach(("/home/jacob/spylight-rails/db/mongo_export/" + "#{file}"), headers: true) do |row|
      storage_hash[row[key_attr]] = row[value_attr]
    end

  end

  colors = {}
  characters = {}
  product_ids_characters = {}
  product_ids_colors = {}

  mongo_import('colors.csv', colors, 'o_id', 'name')
  mongo_import('characters.csv', characters, 'o_id', 'name')

  i = 135
  CSV.foreach("/home/jacob/spylight-rails/db/mongo_export/products.csv", headers: true) do |row|
    product_ids_characters[i] = row['character']
    i += 1
  end

  i = 135
  CSV.foreach("/home/jacob/spylight-rails/db/mongo_export/products.csv", headers: true) do |row|
    product_ids_colors[i] = row['color']
    i += 1
  end

  product_ids_characters.each_pair do |key, value|
    case value
    when 'ObjectID(523f96ba02c82d5c32000007)', 'ObjectID(526b34d702c82d2f24000001)' #Elizabeth Purse, Elizabeth
      product_ids_characters[key] = characters['ObjectID(523f994202c82d5c3200000e)'] #Elizabeth Burke
    when 'ObjectID(5258322502c82d4aad000006)', 'ObjectID(525ae4f702c82d4abc000034)' #Jones, Clinton
      product_ids_characters[key] = characters['ObjectID(523f9c6802c82d5c3200000f)'] #Clinton Jones
    when 'ObjectID(526abeb802c82d4d4f000021)' #Diana
      product_ids_characters[key] = characters['ObjectID(523f9b7002c82d5c2900000a)'] #Diana Barrigan
    when 'ObjectID(525ad57202c82d4ab9000028)' #Neal
      product_ids_characters[key] = characters['ObjectID(52012d857b1d3942f1000003)'] #Neal Caffrey
    else
      product_ids_characters[key] = characters[value]
    end
  end


  product_ids_colors.each_pair do |key, value|
    case value
    when 'ObjectID(51b90ecb7b1d39541f000001)' #gray
      product_ids_colors[key] = colors['ObjectID(521bb3357b1d392b8a000004)'] #Gray
    when 'ObjectID(51b9deef7b1d391249000001)' #blue
      product_ids_colors[key] = colors['ObjectID(51d4723a7b1d3942df000001)'] #Blue
    when 'ObjectID(5268229302c82d4d52000004)' #silver bar
      product_ids_colors[key] = colors['ObjectID(52681e5402c82d4d58000002)'] #Silver
    else
      product_ids_colors[key] = colors[value]
    end
  end

  product_ids_characters.each_pair do |key, value|
    p = Product.find_by_id(key)
    p.character = Character.find_by_name(value)
    p.save!
  end

  product_ids_colors.each_pair do |key, value|
    p = Product.find_by_id(key)
    old_colors = p.colors
    if old_colors
      p.colors.delete(old_colors)
    end
    if value
      p.colors << Color.find_by_name(value)
    end
    p.save!
  end

end
