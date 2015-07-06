Feature: Product Categories

  Scenario: Lists all product_categories
    When I send a request to "/api/v1/product_categories" api
    Then I see the json response
    And I see the product categories response
    Then I receive back a product categories JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | gender                   |


  Scenario: Fetches details of a single product category
    When I send a request to "/api/v1/product_categories/121" api
    Then I see the json response
    And I see the product category response
    Then I receive back a product category JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | gender                   |
