Feature: Site access
  As a merchant
  I want to enter the site
  So I can manage my account

  Scenario: Create an account
    Given I don't have a merchant account
    When I register
    Then I should get a merchant account

  Scenario: Log in
    Given I have a merchant account
    When I enter my login information
    Then I should see the home page for my account

