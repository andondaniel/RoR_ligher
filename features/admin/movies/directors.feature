Feature: Admin Movie Director

  Scenario: listing directors
    Given I'm on the admin page
    When I go to the admin directors page
    Then I see directors listing


   Scenario: search directors
     Given I'm on the admin page
     When I go to the admin directors page
     And I fill in "q[name_contains]" with "a"
     And I click "Filter" button
     Then I see directors listing


  Scenario: Create Director
    Given I'm on the admin page
    When I go to the admin directors page
    And I click "New Director" link
    And I fill in "director[name]" with "director name"
    And I click "Create Director" button
    Then I see the "Director was successfully created." text

  Scenario: View Director
    Given I'm on the admin page
    When I go to the admin directors page
    And I click "View" link
    Then I receive back directors response with valid information for:
      | Name        |
      | Movies      |


  Scenario: Update Director
    Given I'm on the admin page
    When I go to the admin directors page
    And I click "Edit" link
    And I fill in "director[name]" with "director name"
    And I click "Update Director" button
    Then I see the "Director was successfully updated." text
    And I receive back directors response with valid information for:
      | Name        |
      | Movies      |


  @javascript
  Scenario: Delete Director
    Given I'm on the admin page
    When I go to the admin directors page
    And I click delete director
    And I see the "Director was successfully destroyed." text

