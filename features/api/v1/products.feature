Feature: Products api

  Scenario: List all products
    When I send a request to "/api/v1/products" with cache_update="12194"
    Then I see the json response
    And I see the products response
    Then I receive back a products JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | description              |
      | approved                 |
      | slug                     |
      | star_count               |
      | mobile_thumb_image_url   |
      | mobile_full_image_url    |
      | active                   |
      | product_sources          |
      | product_categories       |
      | outfit_ids               |
      | colors                   |
      | brand                    |

  Scenario: Lists all products for a given show
    When I send a request to "/api/v1/shows/the-mindy-project/products" with cache_update=""
    Then I see the json response
    And I see the products response
    Then I receive back a products JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | description              |
      | approved                 |
      | slug                     |
      | star_count               |
      | mobile_thumb_image_url   |
      | mobile_full_image_url    |
      | active                   |
      | product_sources          |
      | product_categories       |
      | outfit_ids               |
      | colors                   |
      | brand                    |

  Scenario: Lists all products for a given character
    When I send a request to "/api/v1/shows/the-mindy-project/characters/323-danny-castellano/products" with cache_update=""
    Then I see the json response
    And I see the products response
    Then I receive back a products JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | description              |
      | approved                 |
      | slug                     |
      | star_count               |
      | mobile_thumb_image_url   |
      | mobile_full_image_url    |
      | active                   |
      | product_sources          |
      | product_categories       |
      | outfit_ids               |
      | colors                   |
      | brand                    |


  Scenario: Lists all products for a given episode
    When I send a request to "/api/v1/shows/the-mindy-project/episodes/the-mindy-project-season1-episode2/products" with cache_update=""
    Then I see the json response
    And I see the products response
    Then I receive back a products JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | description              |
      | approved                 |
      | slug                     |
      | star_count               |
      | mobile_thumb_image_url   |
      | mobile_full_image_url    |
      | active                   |
      | product_sources          |
      | product_categories       |
      | outfit_ids               |
      | colors                   |
      | brand                    |


  Scenario: Lists all products for a given scene
    When I send a request to "/api/v1/shows/the-mindy-project/episodes/the-mindy-project-season1-episode2/scenes/the-mindy-project-season1-episode2-scene-1/products" with cache_update=""
    Then I see the json response
    And I see the products response
    Then I receive back a products JSON response with valid information for:
      | field                    |
      | id                       |
      | name                     |
      | description              |
      | approved                 |
      | slug                     |
      | star_count               |
      | mobile_thumb_image_url   |
      | mobile_full_image_url    |
      | active                   |
      | product_sources          |
      | product_categories       |
      | outfit_ids               |
      | colors                   |
      | brand                    |

    Scenario: Display the details of a given product
      When I send a request to "/api/v1/products/135-ribbed-daily-tank" with cache_update=""
      Then I see the json response
      And I see the products response
      Then I receive back a product JSON response with valid information for:
        | field                    |
        | id                       |
        | name                     |
        | description              |
        | approved                 |
        | slug                     |
        | star_count               |
        | mobile_thumb_image_url   |
        | mobile_full_image_url    |
        | active                   |
        | product_sources          |
        | product_categories       |
        | outfit_ids               |
        | colors                   |
        | brand                    |

