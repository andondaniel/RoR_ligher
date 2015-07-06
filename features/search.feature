@javascript
Feature: Search

  Scenario: search from home page
    When I go to the home page
    And I click "#search" navigation
    And I fill "search" with "nguyen"
    And I submit "#searchform" form
    Then I see the "Search Results: None" text

  Scenario: Shows result
    When I go to the home page
    And I click "#search" navigation
    And I fill valid search
    And I submit "#searchform" form
    Then I see the result search
