Feature: Manage users
  As an admin
  I want to manage user accounts
  So I can let users act as merchants or admins

  Scenario: Merchant request
    Given someone has signed up and said he has a business
    And I am logged in as an admin
    When I visit my account page
    Then I see a reminder of the business request
    And I see a link to edit the business request

  Scenario: Making a merchant
    Given someone has signed up and said he has a business
    And I am logged in as an admin
    When I visit the edit page for the merchant
    Then I see a form to describe the user's business

  Scenario: Review users
    Given I am logged in as an admin
    And there are a lot of users
    When I visit my account page
    Then I see a "Users" link
    When I click "Users"
    Then I see the first ten users
    And I see a link to reach the next page of users
    And I see a "Add User" link

  Scenario: Add user
    Given I am logged in as an admin
    When I visit the "New User" page
    Then I see a form to enter user details
    And I see a select box to mark the user as customer or merchant or admin
    When I fill out the user form
    Then I am on the Users page
    And I see a notice that the new account was created

