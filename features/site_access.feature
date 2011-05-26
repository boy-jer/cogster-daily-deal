Feature: Site access
  As a merchant
  I want to enter the site
  So I can manage my account

  Scenario: Create an account
    Given I don't have a merchant account
    When I register as a merchant
    Then I should get a user account

  Scenario: Log in
    Given I have a merchant account
    When I enter my login information
    Then I am on the account page
    And I see "Looks like you don't have a project set up yet."

  Scenario: Confirm account
    Given I don't have an account
    When I register
    Then I receive an email to confirm
    When I open the confirmation email
    Then I should see "Welcome to Cogster! Activate your account right now." in the email subject
    And I see the confirmation link
    When I follow the confirmation link
    Then I see "Susquehanna Valley"
    And I see "Your account is now active."
