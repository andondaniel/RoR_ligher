Feature: Admin Store

  Scenario: listing store
    Given I'm on the admin page
    When I go to the admin store page
    Then I see listing stores

  Scenario: search stores
    Given I'm on the admin page
    When I go to the admin store page
    And I fill in "q[name_contains]" with "max"
    Then I see listing stores

  Scenario: create store
    Given I'm on the admin page
    When I go to the admin store page
    And I click "New Store" link
    And I fill in "store[name]" with "store name"
    And I click "Create Store" button
    Then I see the "Store was successfully created." text

  Scenario: view store
    Given I'm on the admin page
    When I go to the admin store page
    And I click "View" link
    Then I receive back stores response with valid information for:
      | Id         |
      | Name       |
      | Created At |
      | Updated At |
      | Slug       |

  Scenario: update store
    Given I'm on the admin page
    When I go to the admin store page
    And I click "Edit" link
    And I fill in "store[name]" with "store name"
    And I click "Update Store" button
    Then I see the "Store was successfully updated." text

  @javascript
  Scenario: delete store
    Given I'm on the admin page
    When I go to the admin store page
    And I click delete store
    Then I see the "Store was successfully destroyed." text

