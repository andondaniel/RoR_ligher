Feature: Outfit api

  Scenario: Lists all outfits
    When I send a request to "/api/v1/outfits" with cache_update="5098"
    Then I see the json response
    And I see the outfits response
    Then I receive back a outfits JSON response with valid information for:
      | field                    |
      | id                       |
      | start_time               |
      | end_time                 |
      | character_id             |
      | verified                 |
      | approved                 |


#  Scenario: Lists all outfits for a given show
#    When I send a request to "/api/v1/shows/shameless-us/outfits" with cache_update=""
#    Then I see the json response
#    And I see the outfits response
#    And I want to put the result
#    Then I receive back a outfits JSON response with valid information for:
#      | field                    |
#      | id                       |
#      | start_time               |
#      | end_time                 |
#      | character_id             |
#      | verified                 |
#      | approved                 |


#  Scenario: Lists all outfits for a given movie
#    When  I send a request to "v1/movies/5-veronica-mars/outfits" with cache_update=""
#    Then I see the json response
#    And I see the outfits response
#    And I want to put the result
