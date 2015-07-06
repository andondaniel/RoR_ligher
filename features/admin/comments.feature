Feature: Admin Comments

  Scenario: listing comment
    Given I'm on the admin page
    When I go to the active admin comments page
    Then I see the "Active Admin Comments" text
    And I see listing comments


  Scenario: Search comments
    Given I'm on the admin page
    When I go to the active admin comments page
    And I fill in "q[body_contains]" with "fixed"
    And I click "Filter" button
    Then I see the "fixed" text


  Scenario: View comment
    Given I'm on the admin page
    When I go to the active admin comments page
    And I click "View" link
    Then I receive back comments response with valid information for:
      | Id                       |
      | Author                   |
      | Resource Type            |
      | Resource                 |
      | Resource Creator         |
      | Body                     |