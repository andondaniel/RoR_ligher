When %{I go to the home page} do
  visit root_path
end

When %{I go to the user registration} do
  visit new_user_path
end

When %{I go to the sign in page} do
  visit '/sessions/new'
end

When %{I go to the admin page} do
  visit '/admin'
end