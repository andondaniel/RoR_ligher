Feature: Admin Product

  Scenario: listing product
    Given I'm on the admin page
    When I go to the admin product page
    Then I see listing products


  Scenario: search products
    Given I'm on the admin page
    When I go to the admin product page
    And I fill in "q[name_contains]" with "solid"
    And I click "Filter" button
    Then I see listing products

  Scenario: view product
    Given I'm on the admin page
    When I go to the admin product page
    And I click "View" link
    Then I receive back products response with valid information for:
      | Flagged               |
      | Missing Verifications |
      | Approved              |
      | Reviewers             |
      | Creator               |
      | Name                  |
      | Description           |
      | Brand                 |
      | Product Categories    |
      | Slug                  |
      | Shows                 |
      | Characters            |
      | Episodes              |
      | Old Character         |
      | Old Episodes          |


  Scenario: update product
    Given I'm on the admin page
    When I go to the admin product page
    And I click "Edit" link
    And I fill in "product[name]" with "product name"
    And I click "Update Product" button
    Then I see the "Product was successfully updated." text

  Scenario: create product
    Given I'm on the admin page
    When I go to the admin product page
    And I click "New Product" link
    And I fill in "product[name]" with "product name"
    And I click "Create Product" button
    Then I see the "Product was successfully created." text

  @javascript
  Scenario: Delete product
    Given I'm on the admin page
    When I go to the admin product page
    And I click delete product
    Then I see the "Product was successfully destroyed." text

