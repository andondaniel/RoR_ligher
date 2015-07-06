Feature: User Register
  In order to use Spylight to shopping
  As an buyer
  I want to sign up

  Scenario: invalid email
    Given I go to the user registration
    And I fill in First name
    And I fill in Last name
    And I fill in Password
    And I fill in Password confirmation
    And I click "Register" button
    Then I see the "#user_email_input" with "can't be blank" messages

  Scenario: invalid first name
    Given I go to the user registration
    When I fill in Email
    And I fill in Last name
    And I fill in Password
    And I fill in Password confirmation
    And I click "Register" button
    Then I see the "#user_profile_attributes_first_name_input" with "can't be blank" messages

  Scenario: invalid last name
    Given I go to the user registration
    When I fill in Email
    And I fill in First name
    And I fill in Password
    And I fill in Password confirmation
    And I click "Register" button
    Then I see the "#user_profile_attributes_last_name_input" with "can't be blank" messages


  Scenario: invalid password
    Given I go to the user registration
    When I fill in Email
    And I fill in First name
    And I fill in Last name
    And I click "Register" button
    Then I see the "#user_password_input" with "can't be blank" messages

  Scenario: not match password
    Given I go to the user registration
    And I fill in Email
    And I fill in First name
    And I fill in Last name
    And I fill in Password
    And I click "Register" button
    Then I see the "#user_password_confirmation_input" with "doesn't match Password and can't be blank" messages

  Scenario: sign up successfully
    When I go to the user registration
    And I fill in Email
    And I fill in First name
    And I fill in Last name
    And I fill in Password
    And I fill in Password confirmation
    And I click "Register" button
    Then I see the "Your account was successfully created." message
