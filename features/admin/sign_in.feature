Feature: Admin Sign in

  Scenario: sign in successfully
    When I go to the home page
    Then I click "Log In" link
    Then I fill in "email" with "john@john.john"
    And I fill in "password" with "123"
    And I click "Sign In" button
    Then I see the "Logged in!" message
    And I go to the admin page
    And I see the "Dashboard" link
    And I see the "Movies" link
    And I see the "Products" link
    And I see the "TV" link
