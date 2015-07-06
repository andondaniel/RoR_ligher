#-------------------- Brands Steps ---------------------
When %{I go to the admin brand page} do
  visit '/admin/brands'
end

And %{I see listing brands} do
  page.find("#index_table_brands").should have_selector('tr', visible: true)
end

Then %r{^I receive back brands response with valid information for:$} do |brands_fields|
  fields = brands_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete brand$/) do
  step %{I click "View" link}
  step %{I click "Delete Brand" link}
  page.driver.browser.switch_to.alert.accept
end


#------------------------- Colors Steps --------------------------

When %{I go to the admin color page} do
  visit '/admin/colors'
end

And %{I see listing colors} do
  page.find("#index_table_colors").should have_selector('tr', visible: true)
end

Then %r{^I receive back colors response with valid information for:$} do |colors_fields|
  fields = colors_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete color$/) do
  step %{I click "View" link}
  step %{I click "Delete Color" link}
  page.driver.browser.switch_to.alert.accept
end

# ----------------------- Outfits Steps -------------------------------
When %{I go to the admin outfit page} do
  visit '/admin/outfits'
end

And %{I see listing outfits} do
  page.find("#index_table_outfits").should have_selector('tr', visible: true)
end

Then %r{^I receive back outfits response with valid information for:$} do |outfits_fields|
  fields = outfits_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete outfit$/) do
  step %{I click "View" link}
  step %{I click "Delete Outfit" link}
  page.driver.browser.switch_to.alert.accept
end

#-------------------- Product categories ---------------------------------------
When %{I go to the admin product category page} do
  visit '/admin/product_categories'
end

And %{I see listing product category} do
  page.find("#index_table_product_categories").should have_selector('tr', visible: true)
end

Then %r{^I receive back product_categories response with valid information for:$} do |product_categories_fields|
  fields = product_categories_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete product categoy/) do
  step %{I click "View" link}
  step %{I click "Delete Product Category" link}
  page.driver.browser.switch_to.alert.accept
end

#-------------------- Product sét ---------------------------------------
When %{I go to the admin product set page} do
  visit '/admin/product_sets'
end

And %{I see listing product set} do
  page.find("#index_table_product_sets").should have_selector('tr', visible: true)
end

Then %r{^I receive back product sets response with valid information for:$} do |product_sets_fields|
  fields = product_sets_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete product set/) do
  step %{I click "View" link}
  step %{I click "Delete Product Set" link}
  page.driver.browser.switch_to.alert.accept
end


#-------------------- Products Steps ---------------------
When %{I go to the admin product page} do
  visit '/admin/products'
end

And %{I see listing products} do
  page.find("#index_table_products").should have_selector('tr', visible: true)
end

Then %r{^I receive back products response with valid information for:$} do |products_fields|
  fields = products_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete product$/) do
  step %{I click "View" link}
  step %{I click "Delete Product" link}
  page.driver.browser.switch_to.alert.accept
end


#-------------------- Stores Steps ---------------------
When %{I go to the admin store page} do
  visit '/admin/stores'
end

And %{I see listing stores} do
  page.find("#index_table_stores").should have_selector('tr', visible: true)
end

Then %r{^I receive back stores response with valid information for:$} do |stores_fields|
  fields = stores_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete store$/) do
  step %{I click "View" link}
  step %{I click "Delete Store" link}
  page.driver.browser.switch_to.alert.accept
end
