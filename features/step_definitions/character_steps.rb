And %{I see character image cover} do
  page.should have_xpath("//img[@alt='Character image cover']")
end

Then %{I click character link} do
  page.find(".view-all-character").find("a", match: :first).click
end