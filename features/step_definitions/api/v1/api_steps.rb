#---------------------- Application Api Steps-----------------
When(/^I send a request to "(.*?)" api$/) do |api_request|
  page.driver.get(api_request)
end


When(/^I send a request to "(.*?)" with cache_update="(.*?)"$/) do |api_request, cache_update|
  page.driver.get(api_request, {cache_update: cache_update.to_i})
end


#---------------------- Character Steps--------------------
When(/^I send a request \(top_nine = "(.*?)", movie_slug = "(.*?)", show_slug = "(.*?)"\) to characters api$/) do |top_nine, movie_slug, show_slug|
  slug = show_slug
  slug = movie_slug if movie_slug.present?
  page.driver.get("/api/v1/shows/#{slug}/characters", {cache_update: 5, top_nine: top_nine})
end


And (/^I see character result less than or equal "(.*?)"$/) do |number|
  JSON.parse(page.body).size.should <= number.to_i
end

#---------------------- Search Steps--------------------------

When(/^I send a request \(search = "(.*?)", quantity = (\d+), shows = "(.*?)", characters= "(.*?)"\) to search api$/) do |search, quantity, shows, characters|
  page.driver.get("/api/v1/search", {search: search, quantity: quantity.to_i, shows: shows, characters: characters})
end


Then %{the response should be JSON} do
  JSON.parse(page.body).is_a?(Hash)
end

#--------------------- Products Steps -----------------------------
When %{I see the json response} do
  JSON.parse(page.body).is_a?(Hash)
end

When %{I see the products response} do
  JSON.parse(page.body)['products'].is_a?(Hash)
end

Then %r{^I receive back a products JSON response with valid information for:$} do |product_fields|
  product_json = JSON.parse(page.body)["products"].first.keys
  fields = product_fields.raw.flatten
  fields.each do |field|
    product_json.first[field].should_not nil
  end
end


Then %r{^I receive back a product JSON response with valid information for:$} do |product_fields|
  product_json = JSON.parse(page.body)["product"].keys
  fields = product_fields.raw.flatten
  fields.each do |field|
    product_json.first[field].should_not nil
  end
end

#----------------------- Product categories steps---------------------------------
When %{I see the product categories response} do
  JSON.parse(page.body)['product_categories'].is_a?(Hash)
end


When %{I see the product category response} do
  JSON.parse(page.body)['product_category'].is_a?(Hash)
end

Then %r{^I receive back a product categories JSON response with valid information for:$} do |product_categories_fields|
  product_json = JSON.parse(page.body)["product_categories"].first.keys
  fields = product_categories_fields.raw.flatten
  fields.each do |field|
    product_json.first[field].should_not nil
  end
end

Then %r{^I receive back a product category JSON response with valid information for:$} do |product_categories_fields|
  product_json = JSON.parse(page.body)["product_category"].keys
  fields = product_categories_fields.raw.flatten
  fields.each do |field|
    product_json.first[field].should_not nil
  end
end


#--------------------------Outfits steps------------------------------------------------
Then %{I see the outfits response} do
  JSON.parse(page.body)['outfits'].is_a?(Hash)
end

Then %r{^I receive back a outfits JSON response with valid information for:$} do |outfits_fields|
  outfit_json = JSON.parse(page.body)["outfits"].first.keys
  fields = outfits_fields.raw.flatten
  fields.each do |field|
    outfit_json.first[field].should_not nil
  end
end
