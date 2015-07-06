When(/^I click "(.*?)" button$/) do |button|
  click_button(button)
end

Then(/^I see the "(.*?)" link$/) do |text|
  expect(page.find("a", :text => text, match: :first)).to have_text(text)
end

Then %{I want to put the result} do
  puts page.body
end


Then(/^I see the "(.*?)" with "(.*?)" messages$/) do |id, message|
  expect(page.find(id)).to have_text(message)
end

When(/^I click "(.*?)" link$/) do |link|
  find("a", :text => link, match: :first).click
end

When(/^I click "(.*?)" link on navigation$/) do |link|
  find("a", text: link, href: "#").click
end

When(/^I click "(.*?)" navigation/) do |link|
  find(link).click
end


Then(/^I see the "(.*?)" text$/) do |text|
  expect(page).to have_text(text, match: :first)
end

Then(/^I see the "(.*?)" message$/) do |text|
  expect(page.find(".alert_message")).to have_text(text)
end

Then(/^I see the "(.*?)" text in header/) do |text|
  expect(page.find(".main-navigation")).to have_text(text)
end

Then(/^I see the "(.*?)" text in dropdown/) do |text|
  expect(page.find(".drop-down")).to have_text(text)
end


Then(/^I fill in "(.*?)" with "(.*?)"$/) do |name, val|
  fill_in(name, with: val, match: :first)
end

Then(/^I fill "(.*?)" with "(.*?)"$/) do |id, val|
  fill_in(id, with: val, match: :first)
end

Then(/^I submit "(.*?)" form$/) do |form|
  page.execute_script("$('#{form}').submit()")
end

Given /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end

Given %{There are user account} do
  FactoryGirl.create(:user, email: "jacob@gmail.com", password: "123456", password_confirmation: "123456")
end

And %{I see the sign_in modal} do
  page.should have_selector('#login', visible: true)
end
