Feature: Admin Users

  Scenario: listing user
    Given I'm on the admin page
    When I go to the admin user page
    Then I see listing user

  Scenario: Search users
    Given I'm on the admin page
    When I go to the admin user page
    And I fill "q[role_contains]" with "Basic"
    And I click "Filter" button
    And I see the "Basic" role


  Scenario: New User with fail validation
    Given I'm on the admin page
    When I go to the admin user page
    And I click "New User" link
    Then I see the "New User" text
    And I click "Create User" button
    And I see the "First name can't be blank" text
    And I see the "Email can't be blank" text


  Scenario: New User successfully
    Given I'm on the admin page
    When I go to the admin user page
    And I click "New User" link
    And I fill in "user[profile_attributes][first_name]" with "bob"
    And I fill in "user[profile_attributes][last_name]" with "bob"
    And I fill in "user[email]" with "bob@bob1.com"
    And I fill in "user[password]" with "123"
    And I fill in "user[password_confirmation]" with "123"
    And I click "Create User" button
    And I see the "User was successfully created." text

  Scenario: Edit user
    Given I'm on the admin page
    When I go to the admin user page
    And I click edit user
    And I see Edit User form
    Then I click "Update User" button
    And I see the "User was successfully updated." text

  @javascript
  Scenario: Delete user
    Given I'm on the admin page
    When I go to the admin user page
    And I click delete user
    Then I see the "User was successfully destroyed." text
