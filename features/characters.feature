Feature: Characters

  @javascript
  Scenario: Character show
    When I go to the home page
    Then I click "Log In" link
    And I fill in "email" with "bob@bob.bob"
    And I fill in "password" with "123"
    And I click "Sign In" button
    Then I click character link
    And I see the "SHOW OUTFITS" text
    And I see the "SHOW PRODUCTS" text