# == Schema Information
#
# Table name: product_sets
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  flag       :boolean          default(FALSE)
#  approved   :boolean          default(FALSE)
#

class ProductSet < ActiveRecord::Base
	include Reviewable
	has_many :products
	belongs_to :last_updater, class_name: "User"


	#Would rather just overwrite the << method, but couldnt figure out how to access it (singleton classes confusing)
	# def products
	# 	@products = []
	# 	class << @products
	# 		def <<(*products_to_be_added)		
	# 			puts "triggers new method"
	# 			all_similar_products = []
	# 			all_similar_products = products_to_be_added
	# 			products_to_be_added.each do |p|
	# 				if p.product_set
	# 					all_similar_products << p.similar_products
	# 					p.product_set.destroy
	# 				else
	# 					next
	# 				end
	# 			end
	# 			super(all_similar_products)
	# 		end
	# 	end
	# 	super
	# end

	#Could probably be improved by using Ruby Sets instead of Arrays
	attr_reader :add_products

	def admin_permalink
		admin_post_path(self)
	end

	def add_products
		self.products
	end

	#doesnt allow products to be removed
	def add_products=(new_product_ids)
		ids = new_product_ids.select{|p| !p.blank?}
		unless ids.blank?
			all_similar_product_ids = ids
			product_set_ids = []
			ids.each do |p_id|
				p = Product.find(p_id)
				if p.product_set
					product_set_ids << p.product_set.id
					p.product_set.products.each do |prod|
						all_similar_product_ids << prod.id.to_s
					end
					all_similar_product_ids.uniq!
				else
					next
				end
			end
			product_set_ids.uniq!
			ProductSet.destroy(product_set_ids)
			self.products << Product.find(all_similar_product_ids)
		end
		#unapprove updated product sets
		self.approved = false
	end



end
