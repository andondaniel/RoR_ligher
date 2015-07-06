Then %{I click movie link} do
  page.find(".movie-drop-down").find("a", match: :first).click
end