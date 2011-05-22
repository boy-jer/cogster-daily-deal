Feature: Editing a business
  As a merchant
  I want to edit my business profile
  So I can let customers know about my business

  Background:
    Given I am logged in as a merchant

  Scenario: Editing profile
    When I go to the account page
    And I click "Edit Business"
    Then I see "Edit Business Profile"
    And I see "Business Hours"
    When I set my business hours
    Then I see "Business profile updated"
    When I go to my business page
    Then I see my hours of operation

  Scenario: Fail Edit
    When I go to the account page
    And I click "Edit Business"
    And I screw up the business hours
    Then I see "Edit Business Profile"
    And I see the days are closed

  Scenario: Editing Logo
    When I go to the edit business page
    And I click "upload a logo"
    Then I see "Edit Business Logo"
    When I upload a logo
    Then I see "Business profile updated"
    When I go to my business page
    Then I see my logo
