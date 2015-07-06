Feature: Admin Network

  Scenario: listing network
    Given I'm on the admin page
    When I go to the admin network page
    Then I see listing networks

  Scenario: search networks
    Given I'm on the admin page
    When I go to the admin network page
    And I fill in "q[name_contains]" with "bc"
    And I click "Filter" button
    Then I see listing networks

  Scenario: view network
    Given I'm on the admin page
    When I go to the admin network page
    And I click "View" link
    Then I receive back networks response with valid information for:
      | Id          |
      | Name        |
      | Created At  |
      | Updated At  |
      | Creator     |
      | Approved    |
      | Verified    |


  Scenario: update network
    Given I'm on the admin page
    When I go to the admin network page
    And I click "Edit" link
    And I fill in "network[name]" with "network name"
    And I click "Update Network" button
    Then I see the "Network was successfully updated." text

  Scenario: create network
    Given I'm on the admin page
    When I go to the admin network page
    And I click "New Network" link
    And I fill in "network[name]" with "network name"
    And I click "Create Network" button
    Then I see the "Network was successfully created." text


  @javascript
  Scenario: delete network
    Given I'm on the admin page
    When I go to the admin network page
    And I click delete network
    Then I see the "Network was successfully destroyed." text

