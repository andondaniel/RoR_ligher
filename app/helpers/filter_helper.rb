module FilterHelper
  def filter
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