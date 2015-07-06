#----------------------- directors steps ----------------------------
When %{I go to the admin directors page} do
  visit '/admin/directors'
end

And %{I see directors listing} do
  page.find("#index_table_directors").should have_selector('tr', visible: true)
end

When(/^I click delete director$/) do
  visit "/admin/directors/#{Director.first.id}"
  step %{I click "Delete Director" link}
  page.driver.browser.switch_to.alert.accept
end

Then %r{^I receive back directors response with valid information for:$} do |director_fields|
  fields = director_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end


#--------------------------- Movies Steps -------------------------------
When %{I go to the admin movies page} do
  visit '/admin/movies'
end

And %{I see listing movies} do
  page.find("#index_table_movies").should have_selector('tr', visible: true)
end

Then %r{^I receive back movies response with valid information for:$} do |movie_fields|
  fields = movie_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete movie$/) do
  visit "/admin/movies/#{Movie.first.slug}"
  step %{I click "Delete Movie" link}
  page.driver.browser.switch_to.alert.accept
end


#---------------------------Producers Step --------------------------------------

When %{I go to the admin producers page} do
  visit '/admin/producers'
end

And %{I see listing producers} do
  page.find("#index_table_producers").should have_selector('tr', visible: true)
end

Then %r{^I receive back producers response with valid information for:$} do |producers_fields|
  fields = producers_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete producer$/) do
  step %{I click "View" link}
  step %{I click "Delete Producer" link}
  page.driver.browser.switch_to.alert.accept
end
