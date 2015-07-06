Feature: Sign in


  Scenario: sign in successfully
    Given There are user account
    When I go to the home page
    Then I click "Log In" link
    Then I fill in "email" with "bob@bob.bob"
    And I fill in "password" with "123"
    And I click "Sign In" button
    And I see the "Logged in!" message

  Scenario: username and password not match
    Given There are user account
    When I go to the home page
    Then I click "Log In" link
    Then I fill in "email" with "jacob@gmail.com"
    And I fill in "password" with "12"
    And I click "Sign In" button
    Then I see the "Email or password is invalid" message