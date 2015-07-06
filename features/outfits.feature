@javascript
Feature: Outfit

  Scenario: Feature outfit home
    When I go to the home page
    And I see 2 outfit feature
    And I see 8 outfit product

  Scenario: Outfit popup
    When I go to the home page
    And I see outfit image
    Then I click outfit link
    And I see outfit popup