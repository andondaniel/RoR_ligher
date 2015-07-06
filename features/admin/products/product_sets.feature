Feature: Admin Product Set

  Scenario: listing product set
    Given I'm on the admin page
    When I go to the admin product set page
    Then I see listing product set

  Scenario: view product set
    Given I'm on the admin page
    When I go to the admin product set page
    And I click "View" link
    Then I receive back product sets response with valid information for:
      | Id            |
      | Product Slugs |
      | Name          |
      | Slug          |

  Scenario: Create product set
    Given I'm on the admin page
    When I go to the admin product set page
    And I click "New Product Set" link
    And I click "Create Product set" button
    Then I see the "Product set was successfully created." text


  Scenario: Update product set
    Given I'm on the admin page
    When I go to the admin product set page
    And I click "Edit" link
    And I click "Update Product set" button
    Then I see the "Product set was successfully updated." text



  @javascript
  Scenario: Delete product set
    Given I'm on the admin page
    When I go to the admin product set page
    And I click delete product set
    Then I see the "Product set was successfully destroyed." text


