Feature: Admin Product Categories

  Scenario: listing product category
    Given I'm on the admin page
    When I go to the admin product category page
    Then I see listing product category

  Scenario: search product category
    Given I'm on the admin page
    When I go to the admin product category page
    And I fill in "q[name_contains]" with "Hat"
    And I click "Filter" button
    Then I see listing product category


  Scenario: Create product category with wrong validation
    Given I'm on the admin page
    When I go to the admin product category page
    And I click "New Product Category" link
    And I fill in "product_category[name]" with "product name"
    And I click "Create Product category" button
    Then I see the "Gender is not included in the list" text

  Scenario: Create product category with correct validation
    Given I'm on the admin page
    When I go to the admin product category page
    And I click "New Product Category" link
    And I fill in "product_category[name]" with "product name"
    And I select "product_category[gender]" with "Male"
    And I click "Create Product category" button
    Then I see the "Product category was successfully created." text


  Scenario: view product category
    Given I'm on the admin page
    When I go to the admin product category page
    And I click "View" link
    Then I receive back product_categories response with valid information for:
      | Name |


   Scenario: Update product category
     Given I'm on the admin page
     When I go to the admin product category page
     And I click "Edit" link
     And I fill in "product_category[name]" with "product name"
     And I click "Update Product category" button
     Then I see the "Product category was successfully updated." text


   @javascript
   Scenario: Delete product category
     Given I'm on the admin page
     When I go to the admin product category page
     And I click delete product categoy
     Then I see the "Product category was successfully destroyed." text
