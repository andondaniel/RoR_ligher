@javascript
Feature: Home

  Scenario: see TV link
    When I go to the home page
    Then I see the "TV" text in header
    And I click "#tv" navigation
    And I see the "Shows" text in dropdown
    And I see the "Characters" text in dropdown
    And I see the "Episodes" text in dropdown

  Scenario: see Movie link
    When I go to the home page
    Then I see the "MOVIES" text in header
    And I click "#movies" navigation
    And I see the movies

  Scenario: see Category link
    When I go to the home page
    Then I see the "CATEGORIES" text in header
    And I click "#categories" navigation
    And I see the categories

  Scenario: see Outfit image
    When I go to the home page
    And I see outfit image