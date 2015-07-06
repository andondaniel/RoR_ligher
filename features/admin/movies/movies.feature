Feature: Admin movies

  Scenario: listing movies
    Given I'm on the admin page
    When I go to the admin movies page
    Then I see listing movies


   Scenario: search movies
     Given I'm on the admin page
     When I go to the admin movies page
     And I fill in "q[name_contains]" with "a"
     And I click "Filter" button
     And I see listing movies

   Scenario: View movie
     Given I'm on the admin page
     When I go to the admin movies page
     And I click "View" link
     Then I receive back movies response with valid information for:
       | Flagged               |
       | Missing Verifications |
       | Approved              |
       | Completed             |
       | Paid                  |
       | Reviewers             |
       | Creator               |
       | Name                  |
       | Directors             |
       | Producers             |
       | Release Date          |
       | Tagline               |
       | Approved Outfit Count |
       | Image Count           |


  Scenario: Create Movie
    Given I'm on the admin page
    When I go to the admin movies page
    And I click "New Movie" link
    And I fill in "movie[name]" with "movie name"
    And I click "Create Movie" button
    Then I see the "Movie was successfully created." text

  Scenario: Edit movie
    Given I'm on the admin page
    When I go to the admin movies page
    And I click "Edit" link
    And I fill in "movie[name]" with "movie name"
    And I click "Update Movie" button
    Then I see the "Movie was successfully updated." text


  @javascript
  Scenario: Delete Movie
    Given I'm on the admin page
    When I go to the admin directors page
    And I click delete movie
    And I see the "Movie was successfully destroyed." text

