Feature: Merchant page
  As a merchant
  I want to set up projects
  So I can make money

  Background:
    Given I am logged in as a merchant

  Scenario: Start a project
    Given I do not have a project
    When I visit my account home page
    Then I see a link to create a project 
    And I do not see details of my current project
    When I click "Click here to set up your first project"
    Then I see "Create a Fundraising Project"
    When I create a project
    Then I am on the account page
    And I see details of my current project
