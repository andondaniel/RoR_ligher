Feature: Admin Characters

  Scenario: listing character
    Given I'm on the admin page
    When I go to the admin character page
    Then I see listing characters


  Scenario: search characters
    Given I'm on the admin page
    When I go to the admin character page
    And I fill in "q[name_contains]" with "Tansy"
    And I click "Filter" button
    Then I see listing characters


  Scenario: view character
    Given I'm on the admin page
    When I go to the admin character page
    And I click "View" link
    Then I receive back characters response with valid information for:
      | Flagged               |
      | Missing Verifications |
      | Approved              |
      | Reviewers             |
      | Creator               |
      | Name                  |
      | Slug                  |
      | Description           |
      | Gender                |
      | Guest                 |
      | Actor                 |
      | Importance            |
      | Cover Photo           |
      | Thumbnail Photo       |
      | Show                  |

   Scenario: update character
     Given I'm on the admin page
     When I go to the admin character page
     And I click "Edit" link
     And I fill in "character[name]" with "character name"
     And I click "Update Character" button
     Then I see the "Character was successfully updated." text


  Scenario: create character
    Given I'm on the admin page
    When I go to the admin character page
    And I click "New Character" link
    And I fill in "character[name]" with "character name"
    And I select "character[gender]" with "male"
    And I click "Create Character" button
    Then I see the "Character was successfully created." text


  @javascript
  Scenario: delete character
    Given I'm on the admin page
    When I go to the admin character page
    And I click delete character
    Then I see the "Character was successfully destroyed." text

