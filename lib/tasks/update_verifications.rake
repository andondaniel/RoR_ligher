namespace :update_verifications do
  desc "Incrementally update verifications."
  task :all => :environment do

    Dir[Rails.root.to_s + '/app/models/**/*.rb'].each do |file| 
      begin
        require file
      rescue
      end
    end

    verified_models = ActiveRecord::Base.subclasses.keep_if{ |klass| defined? klass.verified }


    verified_models.each do |klass|
    	total = klass.count
    	updated = 0
      current_id = 1
    	while updated < total
    		begin
          #all verifications happen after save so we just need to save each object
        	klass.find(current_id).save
        	current_id += 1
          updated += 1
        	puts "completed #{updated}/#{total} #{klass} verifications"
      	rescue => e
          current_id += 1
      	end
      end
    end
  end
end