Feature: Admin questions

  Scenario: listing questions
    Given I'm on the admin page
    When I go to the admin questions page
    And I see the listing questions

  Scenario: search questions
    Given I'm on the admin page
    When I go to the admin questions page
    And I fill in "q[title_contains]" with "outfit"
    And I click "Filter" button
    And I see the listing questions
    And I see the outfit result

   Scenario: View question
     Given I'm on the admin page
     When I go to the admin questions page
     And I click "View" link
     Then I receive back questions response with valid information for:
       | Title            |
       | Description      |
       | Creator          |
       | Answered         |


  Scenario: Update question
    Given I'm on the admin page
    When I go to the admin questions page
    And I click "Edit" link
    And I fill in "question[title]" with "test title"
    And I click "Update Question" button
    Then I see the "Question was successfully updated." text


  Scenario: New question
    Given I'm on the admin page
    When I go to the admin questions page
    And I click "New Question" link
    And I fill in "question[title]" with "test title"
    And I fill in "question[description]" with "test description"
    And I click "Create Question" button
    Then I see the "Question was successfully created." text

  @javascript
  Scenario: Delete question
    Given I'm on the admin page
    When I go to the admin questions page
    And I click delete question
    Then I see the "Question was successfully destroyed." text