And %{I fill valid search} do
  fill_in("search",  with: Show.first.name, match: :first)
end

And %{I see the result search} do
  page.should have_text(Show.first.name)
end