Feature: Manage projects
  As an admin
  I want to manage project options
  So merchants have choices for how to run their projects

  Scenario: Review project options
    Given I am logged in as an admin
    And there are project options in the system
    When I visit my account page
    Then I see a "Project Options" link
    When I click "Project Options"
    Then I see all the project options in Cogster
    And I see how many active projects are using each option
    And I see a link to edit each project option
    And I see a button to delete any project option 
    And I see "Add New Project Option"

  Scenario: Add campaign option
    Given I am logged in as an admin
    When I visit the "Add New Project Option" page
    Then I see a form to enter a description for the project option
    And I see "Add New Interval" 
    When I fill out the project option form
    Then I am on the project options page
    And I see the new project option

