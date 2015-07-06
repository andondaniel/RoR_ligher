Feature: Admin Dashboard

  Scenario: Recent Update Content
    Given I'm on the admin page
    When I go to the admin dashboard page
    And I see the "Recently Updated Content" text
    And I see the items update