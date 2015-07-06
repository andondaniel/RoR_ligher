And %{I see outfit image} do
  page.should have_css('div.featured-outfit')
end

Then %{I click outfit link} do
  page.find(".featured-outfit", match: :first).find("a", match: :first).click
end

And %{I see outfit popup} do
  page.should have_selector('#product_details', visible: true)
end

And %{I see 2 outfit feature} do
  page.all(".featured-outfit").size.should == 2
end

And %{I see 8 outfit product} do
  page.all(".outfit-product").size.should == 8
end