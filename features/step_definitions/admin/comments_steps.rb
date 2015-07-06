When %{I go to the active admin comments page} do
  visit '/admin/active_admin_comments'
end

And %{I see listing comments} do
  page.find("#index_table_active_admin_comments").should have_selector('tr', visible: true)
end

Then %r{^I receive back comments response with valid information for:$} do |comment_fields|
  fields = comment_fields.raw.flatten
  fields.each do |text|
    expect(page).to have_text(text)
  end
end