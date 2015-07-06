When %{I go to the admin dashboard page} do
  visit '/admin/dashboard'
end

And %{I see the items update} do
  page.find(".recent-updates").all("tr.odd").size.should > 0
end