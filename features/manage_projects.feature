Feature: Manage campaigns
  As an admin
  I want to manage campaign options
  So merchants have choices for how to run their projects

  Scenario: Review campaign options
    Given I am logged in as an admin
    When I visit the home page
    Then I see a "Campaigns" link
    When I click "Campaigns"
    Then I see all the campaign options in Cogster
    And I see how many active projects are using each option
    And I see how many projects lifetime have used each option
    And I see a link to edit each campaign option
    And I see a button to delete any campaign option that has no active campaigns
    And I see a "New Campaign" link

  Scenario: Add campaign option
    Given I am logged in as an admin
    When I visit the "New Campaign" page
    Then I see a form to enter a description for the campaign
    And I see select boxes to set the duration and return rate for the first reimbursement period
    And I see an "Add Reimbursement Period" link
    When I fill out the form
    Then I am taken to the "Campaigns" page
    And I see the new campaign

