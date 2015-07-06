namespace :reprocess_images do
  desc "Incrementally rebuild thumbnails. START=0 & BATCH_SIZE=3 & VERBOSE=false"
  task :all => :environment do
    batch_size = (ENV['BATCH_SIZE'] || ENV['batch_size'] || 3)
    verbose    = (ENV['VERBOSE'] || ENV['verbose'] || nil)

    image_classes = [SceneImage, ShowImage, EpisodeImage, MovieImage, OutfitImage, ProductImage]

    image_classes.each do |klass|
      if klass == SceneImage
        start = 1540
        total = klass.count
      else
        total = klass.count
        start = 0
      end

      while start < total
        puts "Spawning: bundle exec rake reprocess_images:reprocess_some KLASS=#{klass} START=#{start} BATCH_SIZE=#{batch_size} VERBOSE=#{verbose} RAILS_ENV=#{Rails.env}"
        puts %x{bundle exec rake reprocess_images:reprocess_some KLASS=#{klass} START=#{start} BATCH_SIZE=#{batch_size} VERBOSE=#{verbose} RAILS_ENV=#{Rails.env} }
        start = start + batch_size.to_i
      end
    end

  end

  desc "Reprocess a batch of images. START=0 & BATCH_SIZE=3 & VERBOSE=false"
  task :reprocess_some => :environment do
    start      = (ENV['START'] || ENV['start'] || 0)
    batch_size = (ENV['BATCH_SIZE'] || ENV['batch_size'] || 3)
    verbose    = (ENV['VERBOSE'] || ENV['verbose'] || nil)
    klass      = (ENV['KLASS'] || ENV['klass'] || nil).constantize

    puts "klass = #{klass} & start = #{start} & batch_size = #{batch_size}" if verbose
    puts "RAILS_ENV=#{Rails.env}" if verbose

    images = klass.order("id ASC").offset(start).limit(batch_size)
    images.each do |i|
      puts "Re-processing paperclip image on #{klass} ID: #{i.id}" if verbose
      STDOUT.flush
      i.avatar.reprocess!
    end
  end
end