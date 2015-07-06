Feature: Episodes

  @javascript
  Scenario: Episode show
    When I go to the home page
    Then I click outfit link
    And I click episode link
    And I see the "SHOW OUTFITS" text
    And I see the "SHOW PRODUCTS" text