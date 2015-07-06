Feature: Character Api

  Scenario: api/v1/shows/:movie_slug/characters
    When I send a request (top_nine = "true", movie_slug = "2-the-social-network", show_slug = "") to characters api
    And I see character result less than or equal "9"


  Scenario: "/v1/shows/:show_slug/characters"
    When I send a request (top_nine = "true", movie_slug = "", show_slug = "white-collar") to characters api
    And I see character result less than or equal "9"
