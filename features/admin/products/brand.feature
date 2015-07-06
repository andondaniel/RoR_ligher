Feature: Admin brand

  Scenario: listing brand
    Given I'm on the admin page
    When I go to the admin brand page
    Then I see listing brands



  Scenario: search brands
    Given I'm on the admin page
    When I go to the admin brand page
    And I fill in "q[name_contains]" with "Up"
    And I click "Filter" button
    Then I see listing brands

  Scenario: new brand
    Given I'm on the admin page
    When I go to the admin brand page
    And I click "New Brand" link
    And I fill in "brand[name]" with "brand name"
    And I click "Create Brand" button
    Then I see the "Brand was successfully created." text


  Scenario: view brand
    Given I'm on the admin page
    When I go to the admin brand page
    And I click "View" link
    Then I receive back brands response with valid information for:
      | Name   |
      | Slug   |


  Scenario: update brand
    Given I'm on the admin page
    When I go to the admin brand page
    And I click "Edit" link
    And I fill in "brand[name]" with "brand name"
    And I click "Update Brand" button
    Then I see the "Brand was successfully updated." text

  @javascript
  Scenario: delete brand
    Given I'm on the admin page
    When I go to the admin brand page
    And I click delete brand
    Then I see the "Brand was successfully destroyed." text