@javascript
Feature: Categories

  Scenario: Category User not sign-in
    When I go to the home page
    And I click "#categories" navigation
    And I see the categories
    Then I click category link
    And I see the sign_in modal

  Scenario: Category User sign-in
    When I go to the home page
    Then I click "Log In" link
    Then I fill in "email" with "bob@bob.bob"
    And I fill in "password" with "123"
    And I click "Sign In" button
    And I click "#categories" navigation
    And I see the categories
    Then I click category link