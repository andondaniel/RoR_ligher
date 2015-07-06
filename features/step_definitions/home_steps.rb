Then(/^I see the movies$/) do
  page.all('div.movie-drop-down a').size.should > 2
end

Then(/^I see the categories/) do
  page.all('div.category-drop-down a').size.should > 10
end