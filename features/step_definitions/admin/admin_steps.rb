When %{I'm on the admin page} do
  step %{I go to the home page}
  step %{I click "Log In" link}
  step %{I fill in "email" with "john@john.john"}
  step %{I fill in "password" with "123"}
  step %{I click "Sign In" button}
  step %{I go to the admin page}
end