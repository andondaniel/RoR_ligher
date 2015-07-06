namespace :sort_categories do
  desc "Sort products into proper categories based on gender"
  task :gender  => :environment do
  	current_num = 0
		Product.all.each do |p|
			current_num += 1
			puts "working on product #{current_num} of #{Product.count}"
			begin
				character_gender = p.outfits.first.character.gender
				p.product_categories.each do |pc|
					if pc.gender != character_gender
						proper_category = ProductCategory.where(name: pc.name).keep_if{ |cat| cat.gender == character_gender}.first
						if proper_category
							p.product_categories.delete(pc)
							p.product_categories << proper_category
						end
					end
				end
			rescue
				next
			end
		end

	end
end