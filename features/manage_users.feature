Feature: Manage users
  As an admin
  I want to manage user accounts
  So I can let users act as merchants or admins

  Scenario: Merchant request
    Given someone has signed up and said he has a business
    And I am logged in as an admin
    When I visit the home page
    Then I see a reminder of the business request
    And I see a link to make the user a merchant

  Scenario: Making a merchant
    Given someone has signed up and said he has a business
    And I am logged in as an admin
    When I visit the edit page for the user
    Then I see a check box to change the user from customer to merchant
    And I see a form to describe the user's business
    And I see a check box to deny the business request
    And I see a field to mail a response to the user

  Scenario: Review users
    Given I am logged in as an admin
    When I visit the home page
    Then I see a "Users" link
    When I click "Users"
    Then I see the first ten users
    And the users who have requested to become merchants are listed first
    And I see a link to reach the next page of users
    And I see a "New User" link

  Scenario: Add user
    Given I am logged in as an admin
    When I visit the "New User" page
    Then I see a form to enter normal user details
    And I see a check box to mark the user as customer or merchant or admin
    When I fill out the form
    Then I am taken to the "Users" page
    And I see a notice that the new account was created

