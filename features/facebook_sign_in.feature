@javascript
Feature: Facebook Sign In

  Scenario: New User - Login by Facebook
    When I am signed in with provider facebook
    Then I see the "Sign Out" link
    And I see the "Account Created!" text