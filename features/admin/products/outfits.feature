Feature: Admin Outfit

  # TODO: Fix stranger issue for new and edit outfit

  Scenario: listing outfit
    Given I'm on the admin page
    When I go to the admin outfit page
    Then I see listing outfits

  Scenario: search outfits
    Given I'm on the admin page
    When I go to the admin outfit page
    And I click "Filter" button
    Then I see listing outfits

  Scenario: view outfit
    Given I'm on the admin page
    When I go to the admin outfit page
    And I click "View" link
    Then I receive back outfits response with valid information for:
      | Flagged               |
      | Missing Verifications |
      | Approved              |
      | Reviewers             |
      | Creator               |
      | Episodes              |
      | Change                |
      | Character             |
      | Products              |

  @javascript
  Scenario: Delete outfit
    Given I'm on the admin page
    When I go to the admin outfit page
    And I click delete outfit
    Then I see the "Outfit was successfully destroyed." text