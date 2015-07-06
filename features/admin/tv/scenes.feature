Feature: Admin Scene

  Scenario: listing scene
    Given I'm on the admin page
    When I go to the admin scene page
    Then I see listing scenes

  Scenario: search scenes
    Given I'm on the admin page
    When I go to the admin scene page
    And I click "Filter" link
    Then I see listing scenes

  Scenario: view scene
    Given I'm on the admin page
    When I go to the admin scene page
    And I click "View" link
    Then I receive back scenes response with valid information for:
      | Episode       |
      | Movie         |
      | Intro         |
      | Scene Number  |
      | Durations     |
      | Flagged       |
      | Verified      |
      | Approved      |
      | Reviewers     |
      | Creator       |

  # update scene not work
#  Scenario: update scene
#    Given I'm on the admin page
#    When I go to the admin scene page
#    And I click "Edit" link
#    And I fill in "scene[scene_number]" with "10"
#    And I click "Update Scene" button
#    Then I see the "Scene was successfully updated." text

  Scenario: create scene
    Given I'm on the admin page
    When I go to the admin scene page
    And I click "New Scene" link
    And I fill in "scene[scene_number]" with "10"
    And I click "Create Scene" button
    Then I see the "Scene was successfully created." text


  @javascript
  Scenario: delete scene
    Given I'm on the admin page
    When I go to the admin scene page
    And I click delete scene
    Then I see the "Scene was successfully destroyed." text



