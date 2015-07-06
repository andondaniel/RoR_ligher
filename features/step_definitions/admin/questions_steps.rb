When %{I go to the admin questions page} do
  visit '/admin/questions'
end

And %{I see the listing questions} do
  page.find("#index_table_questions").should have_selector('tr', visible: true)
end

And %{I see the outfit result} do
  page.find("#index_table_questions").all(".col-title")[1].should have_text("outfit")
end

Then %r{^I receive back questions response with valid information for:$} do |question_fields|
  fields = question_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end

And %{I click delete question} do
  visit "/admin/questions/#{Question.first.id}"
  step %{I click "Delete Question" link}
  page.driver.browser.switch_to.alert.accept
end