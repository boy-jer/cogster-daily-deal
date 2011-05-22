Feature: Site access
  As a user
  I want to enter the site
  So I can see what deals are available

  Background:
    Given a region named "Susquehanna Valley"

  Scenario: Look at the public site
    When I go to the front page
    Then I should see a list of communities

  Scenario: Choose a community
    When I go to the front page
    And I choose a community
    Then I should be taken to the community page
    And I see "Susquehanna Valley"

  Scenario: Request a community
    When I go to the front page
    And I want a community that isn't listed
    Then I should be taken to a form to request a community

  Scenario: Create an account
    Given I am not logged in
    When I go to the front page
    Then I see "Sign Up" 

  Scenario: Create an account(2)
    Given I am not logged in
    And I don't have a user account
    When I register
    Then I should get a user account

  Scenario: Log in
    Given I register
    When I log in
    Then I see "My Purchases"

  Scenario: Edit password
    Given I register
    When I log in
    Then I am on the account page
    When I click "Edit password"
    And I choose a new password
    Then I see "Your password has been updated" 
#  Scenario: Reset password
#    Given I have a user account
#    When I ask for a new password
#    Then I should get an email with the new password
#    And the old password should no longer work
#    And I should be able to log in with the new password
