Feature: Search Api

  Scenario: /v1/search - Search Spylight
    When I send a request (search = "abc", quantity = 1, shows = "true", characters= "false") to search api
    Then the response should be JSON


  Scenario: /v1/search - Search Spylight
    When I send a request (search = "", quantity = 0, shows = "true", characters= "false") to search api
    Then the response should be JSON