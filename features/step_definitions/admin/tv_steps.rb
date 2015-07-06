#-------------------- Character Steps ---------------------
When %{I go to the admin character page} do
  visit '/admin/characters'
end

And %{I see listing characters} do
  page.find("#index_table_characters").should have_selector('tr', visible: true)
end

Then %r{^I receive back characters response with valid information for:$} do |characters_fields|
  fields = characters_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete character$/) do
  step %{I click "View" link}
  step %{I click "Delete Character" link}
  page.driver.browser.switch_to.alert.accept
end

#-------------------- Episodes Steps ---------------------
When %{I go to the admin episode page} do
  visit '/admin/episodes'
end

And %{I see listing episodes} do
  page.find("#index_table_episodes").should have_selector('tr', visible: true)
end

Then %r{^I receive back episodes response with valid information for:$} do |episodes_fields|
  fields = episodes_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete episode$/) do
  step %{I click "View" link}
  step %{I click "Delete Episode" link}
  page.driver.browser.switch_to.alert.accept
end


#-------------------- Networks Steps ---------------------
When %{I go to the admin network page} do
  visit '/admin/networks'
end

And %{I see listing networks} do
  page.find("#index_table_networks").should have_selector('tr', visible: true)
end

Then %r{^I receive back networks response with valid information for:$} do |networks_fields|
  fields = networks_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete network$/) do
  step %{I click "View" link}
  step %{I click "Delete Network" link}
  page.driver.browser.switch_to.alert.accept
end

#-------------------- Scenes Steps ---------------------
When %{I go to the admin scene page} do
  visit '/admin/scenes'
end

And %{I see listing scenes} do
  page.find("#index_table_scenes").should have_selector('tr', visible: true)
end

Then %r{^I receive back scenes response with valid information for:$} do |scenes_fields|
  fields = scenes_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete scene$/) do
  step %{I click "View" link}
  step %{I click "Delete Scene" link}
  page.driver.browser.switch_to.alert.accept
end

#-------------------- Shows Steps ---------------------
When %{I go to the admin show page} do
  visit '/admin/shows'
end

And %{I see listing shows} do
  page.find("#index_table_shows").should have_selector('tr', visible: true)
end

Then %r{^I receive back shows response with valid information for:$} do |shows_fields|
  fields = shows_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

When(/^I click delete show$/) do
  step %{I click "View" link}
  step %{I click "Delete Show" link}
  page.driver.browser.switch_to.alert.accept
end
