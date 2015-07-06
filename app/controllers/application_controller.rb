class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #
  #TODO protect against CSRF
  # protect_from_forgery with: :exception
  serialization_scope :view_context #allows params to be passed to serializers


  def categories
    @female_category_groups = CategoryGroup.where(gender: "Female")
    @male_category_groups = CategoryGroup.where(gender: "Male")

    # below is the first column of CategoryGroups
    @female_category_groups_first = @female_category_groups.take(7)

    # below is the second column of CategoryGroups
    @female_category_groups_second = @female_category_groups.drop(7).take(7)

    # 1st column of CategoryGroups
    @male_category_groups_first = @male_category_groups.take(7)

    # 2nd column of CategoryGroups
    @male_category_groups_second = @male_category_groups.drop(7).take(7)
  end

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?

  def current_user
    @current_user ||= ::User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? nil : user.id
  end

  def signed_in?
    !!current_user
  end
  helper_method :current_user, :signed_in?

  def user_for_paper_trail
    signed_in? ? current_user : 'Unknown user'
  end

  def filter
    if @products
      # Counting how many of each category there are.
      categories = @products.map{|p| p.product_categories}.flatten.compact.map(&:name)
      count = Hash.new(0)
      categories.each{ |category| count[category] += 1 }
      @categorycount = count.to_a   

      #Counting how many of each gender there are:
      genders = @products.map{|p| p.gender}
      @gendercount = genders.group_by{|g| g}.map{|gender, product| [gender, product.size]}

      #Characters: counts how many of each character there are
      characters = @products.map{|p| p.characters}.flatten.compact
      @charactercount = characters.group_by(&:name).map{|character, product| [character, product.size]}
      
      @filter = params[:filter]
    end

  end

  private

  def set_show
    begin
      @show = Show.find_by_slug(params[:show_id]) 
    rescue 
      @show = Show.first
    end
  end

  def set_networks
    @networks = Network.all.select{|x| x.shows.active.any?}
  end

  def set_movies
    @movies = Movie.approved
  end

  def set_current_network
    @current_network = @current_show ? @current_show.network : Show.approved.first.network
  end

  def set_current_show
    @current_show = @show ? @show : Show.approved.first
  end

  def set_main_menu
    set_show
    set_networks
    set_movies
    set_current_show
    set_current_network
  end



 #  def default_serializer_options
 #  	{root: false}
	# end

end
