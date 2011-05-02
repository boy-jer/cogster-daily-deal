Feature: Site access
  As a merchant
  I want to enter the site
  So I can manage my account

  Scenario: Create an account
    Given I don't have a merchant account
    When I register as a merchant
    Then I should get a user account
    And I am on the account page

  Scenario: Log in
    Given I have a merchant account
    When I enter my login information
    Then I am on the account page
    And I see "My Current Project"

