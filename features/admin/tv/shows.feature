Feature: Admin shows

  Scenario: listing show
    Given I'm on the admin page
    When I go to the admin show page
    Then I see listing shows

  Scenario: search shows
    Given I'm on the admin page
    When I go to the admin show page
    And I fill in "q[name_contains]" with "girl"
    And I click "Filter" button
    Then I see listing shows

  Scenario: view show
    Given I'm on the admin page
    When I go to the admin show page
    And I click "View" link
    Then I receive back shows response with valid information for:
      | Flagged   |
      | Verified  |
      | Approved  |
      | Creator   |
      | Id        |
      | Name      |
      | Slug      |


    Scenario: update show
      Given I'm on the admin page
      When I go to the admin show page
      And I click "Edit" link
      And I fill in "show[name]" with "show name"
      And I click "Update Show" button
      Then I see the "Show was successfully updated." text


   Scenario: create show
     Given I'm on the admin page
     When I go to the admin show page
     And I click "New Show" link
     And I fill in "show[name]" with "show name"
     And I click "Create Show" button
     Then I see the "Show was successfully created." text

  @javascript
  Scenario: delete show
     Given I'm on the admin page
     When I go to the admin show page
     And I click delete show
     Then I see the "Show was successfully destroyed." text
