Feature: Admin feedback


  Scenario: listing feedback
    Given I'm on the admin page
    When I go to the admin feedback page
    Then I see the "Feedbacks" text
    And I see listing feedback

  Scenario: Search feedback
    Given I'm on the admin page
    When I go to the admin feedback page
    And I fill in "q[content_contains]" with "Bug Report"
    And I click "Filter" button
    Then I see the "Bug Report" text

  Scenario: View feedback
    Given I'm on the admin page
    When I go to the admin feedback page
    And I click "View" link
    Then I receive back feedback response with valid information for:
      | Id         |
      | Email      |
      | Category   |
      | Status     |
      | Content    |
      | Created At |
      | Updated At |

  Scenario: New feedback with fail validation
    Given I'm on the admin page
    When I go to the admin feedback page
    And I click "New Feedback" link
    And I see the feedback form
    And I click "Create Feedback" button
    Then I see the "Status is not included in the list" text
    Then I see the "Category is not included in the list" text

  Scenario: New feedback successfully
    Given I'm on the admin page
    When I go to the admin feedback page
    And I click "New Feedback" link
    And I see the feedback form
    And I select "feedback[category]" with "Bug Report"
    And I select "feedback[status]" with "Filed on Github"
    And I fill in "feedback[content]" with "test cucumber"
    And I click "Create Feedback" button
    Then I see the "Feedback was successfully created." text
    And I see the "test cucumber" text

  Scenario: Edit feedback
    Given I'm on the admin page
    When I go to the admin feedback page
    And I click edit "test cucumber" feedback
    And I select "feedback[category]" with "Bug Report"
    And I select "feedback[status]" with "Filed on Github"
    And I fill in "feedback[content]" with "test cucumber"
    And I click "Update Feedback" button
    Then I see the "Feedback was successfully updated" text

  @javascript
  Scenario: Delete Feedback
    Given I'm on the admin page
    When I go to the admin feedback page
    And I click delete "test cucumber" feedback
    Then I see the "Feedback was successfully destroyed." text