Feature: Admin Episodes

  Scenario: listing episode
    Given I'm on the admin page
    When I go to the admin episode page
    Then I see listing episodes


  Scenario: search episodes
    Given I'm on the admin page
    When I go to the admin episode page
    And I fill in "q[name_contains]" with "Harry"
    Then I see listing episodes


  Scenario: view episode
    Given I'm on the admin page
    When I go to the admin episode page
    And I click "View" link
    Then I receive back episodes response with valid information for:
      | Flagged                       |
      | Missing Verifications         |
      | Approved                      |
      | Fashion Consultant Completed  |
      | Audio Sync Completed          |
      | Paid                          |
      | Reviewers                     |
      | Creator                       |
      | Show                          |
      | Season                        |
      | Episode Number                |
      | Name                          |
      | Airdate                       |
      | Tagline                       |
      | Approved Outfit Count         |
      | Image Count                   |


  Scenario: update episode
    Given I'm on the admin page
    When I go to the admin episode page
    And I click "Edit" link
    And I fill in "episode[name]" with "episode name"
    And I click "Update Episode" button
    Then I see the "Episode was successfully updated." text


  Scenario: create episode
    Given I'm on the admin page
    When I go to the admin episode page
    And I click "New Episode" link
    And I select "episode[show_id]" with "Girls"
    And I fill in "episode[name]" with "episode name"
    And I click "Create Episode" button
    Then I see the "Episode was successfully created." text


  @javascript
  Scenario: delete episode
    Given I'm on the admin page
    When I go to the admin episode page
    And I click delete episode
    Then I see the "Episode was successfully detroyed." text


