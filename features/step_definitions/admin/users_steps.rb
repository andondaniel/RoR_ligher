When %{I go to the admin user page} do
  visit '/admin/users'
end

And %{I see listing user} do
  page.find("#index_table_users", match: :first).should have_selector('tr', visible: true)
end

When(/^I see the "(.*?)" role$/) do |role|
  page.find("#index_table_users").find("tr.odd", match: :first).should have_text(role)
end

And %{I click edit user} do
  visit "/admin/users/#{User.first.id}/edit"
end

And %{I see Edit User form} do
  page.should have_text("Edit User")
end


When %{I click delete user} do
  visit "/admin/users/#{User.first.id}"
  step %{I click "Delete User" link}
  page.driver.browser.switch_to.alert.accept
end

