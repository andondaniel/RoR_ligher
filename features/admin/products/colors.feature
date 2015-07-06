Feature: Admin color

  Scenario: listing color
    Given I'm on the admin page
    When I go to the admin color page
    Then I see listing colors


  Scenario: search colors
    Given I'm on the admin page
    When I go to the admin color page
    And I fill in "q[name_contains]" with "Pink"
    And I click "Filter" button
    Then I see listing colors

  Scenario: new color
    Given I'm on the admin page
    When I go to the admin color page
    And I click "New Color" link
    And I fill in "color[name]" with "color name"
    And I click "Create Color" button
    Then I see the "Color was successfully created." text


  Scenario: view color
    Given I'm on the admin page
    When I go to the admin color page
    And I click "View" link
    Then I receive back colors response with valid information for:
      | Name         |
      | Color Code   |


  Scenario: update color
    Given I'm on the admin page
    When I go to the admin color page
    And I click "Edit" link
    And I fill in "color[name]" with "color name"
    And I click "Update Color" button
    Then I see the "Color was successfully updated." text

  @javascript
  Scenario: delete color
    Given I'm on the admin page
    When I go to the admin color page
    And I click delete color
    Then I see the "Color was successfully destroyed." text