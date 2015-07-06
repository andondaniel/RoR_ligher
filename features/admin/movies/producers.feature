Feature: Admin Producers

  Scenario: listing producer
    Given I'm on the admin page
    When I go to the admin producers page
    Then I see listing producers


  Scenario: search producers
    Given I'm on the admin page
    When I go to the admin producers page
    And I fill in "q[name_contains]" with "Dan"
    Then I see listing producers


  Scenario: view producer
    Given I'm on the admin page
    When I go to the admin producers page
    And I click "View" link
    Then I receive back producers response with valid information for:
      | Name   |
      | Movies |


  Scenario: create producer
    Given I'm on the admin page
    When I go to the admin producers page
    And I click "New Producer" link
    And I fill in "producer[name]" with "producer name"
    And I click "Create Producer" button
    Then I see the "Producer was successfully created." text

   Scenario: update producer
     Given I'm on the admin page
     When I go to the admin producers page
     And I click "View" link
     And I click "Edit Producer" link
     And I fill in "producer[name]" with "producer name"
     And I click "Update Producer" button
     Then I see the "Producer was successfully updated." text
     And I receive back producers response with valid information for:
       | Name   |
       | Movies |


  @javascript
  Scenario: delete producer
    Given I'm on the admin page
    When I go to the admin producers page
    And I click delete producer
    Then I see the "Producer was successfully destroyed." text