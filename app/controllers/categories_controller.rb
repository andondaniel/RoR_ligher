class CategoriesController < ApplicationController
  before_action :set_main_menu
  before_action :categories

  PER_PAGE = 15

	def show

    @cg = CategoryGroup.find(params[:id])
    
    if @cg.gender == "Female"
      @gender = "Women's"
    elsif @cg.gender == "Male"
      @gender = "Men's"
    end
    
    # @categories = @cg.product_categories

    # @products = @categories.map{|x| x.products.active.uniq}.flatten.delete_if { |x| x.shows.empty? }

    @products = @cg.products.includes(:product_categories, :characters, :brand, :episodes).active.reject { |x| x.shows.empty? }.uniq

    page = params[:page]

    if @products.any?
      if params[:price_low_high] == "true"
        @products = @products.sort_by! {|p| p.sortable_price || 100000000 }
      end
      if params[:price_high_low] == "true"
        @products = @products.sort_by! {|p| p.sortable_price || 1 }.reverse
      end
      if params[:alphabetical] == "true"
        @products = @products.sort_by! {|p| p.name }
      end
      if page.blank?
        @products = @products.slice(0, PER_PAGE)
        page = 1
      else
        @products = @products.slice(page.to_i * PER_PAGE, PER_PAGE)
        page = page.to_i + 1
      end
    end

    params[:page] = page

		# BELOW: for the product filter

      # @products = @products.blank? ? [] : @products.select {|product| product.present? }
      # categories = @products.map{|product| product.product_categories}.flatten.compact.map(&:name)

      # # Counting how many of each category there are.
      # count = Hash.new(0)
      # categories.each{ |category| count[category] += 1 }
      # @categorycount = count.to_a

      # #Counting how many of each gender there are:
      # #Does this make sense to perform on an already gendered category page?
      # # genders = []
      # # @products.each do |p|
      # #       #chec for products that only exist due to product sets
      # #       if p.characters.any?
      # #             genders << p.characters.first.gender
      # #       end
      # # end
      # # @gendercount = genders.group_by{|g| g}.map{|gender, product| [gender, product.size]}

      # #Characters
      # characters = @products.map{|product| product.characters}.flatten.compact
      # @charactercount = characters.group_by(&:name).map{|character, product| [character, product.size]}

      respond_to do |format|
        format.html
        format.js
      end
	end


  private


  # def set_main_menu
  #   @networks = Network.all.select{|x| x.shows.active.any?}
  #   @movies = Movie.all.approved

  #   @firstnetwork = Network.find(1)
  #   @firstshow = Show.find(16)
  # end



end
