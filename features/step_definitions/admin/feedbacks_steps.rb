When %{I go to the admin feedback page} do
  visit '/admin/feedbacks'
end

And %{I see listing feedback} do
  page.find("#index_table_feedbacks").should have_selector('tr', visible: true)
end

Then %r{^I receive back feedback response with valid information for:$} do |feedback_fields|
  fields = feedback_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

And %{I see the feedback form} do
  page.find("#new_feedback").should have_selector('select', visible: true)
  page.find("#new_feedback").should have_selector('textarea', visible: true)
  page.find("#new_feedback").should have_selector('input', visible: true)
end


Then(/^I select "(.*?)" with "(.*?)"$/) do |name, val|
  select(val, :from => name)
end

When(/^I click edit "(.*?)" feedback$/) do |content|
  visit "/admin/feedbacks/#{Feedback.first.id}/edit"
end

When(/^I click delete "(.*?)" feedback$/) do |content|
  visit "/admin/feedbacks/#{Feedback.first.id}"
  step %{I click "Delete Feedback" link}
  page.driver.browser.switch_to.alert.accept
end


