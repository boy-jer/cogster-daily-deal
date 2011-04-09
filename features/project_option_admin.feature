Feature: Administer Project Options
  As an admin
  I want to set project parameters
  So merchants understand their options for setting up projects

  Background:
    Given I am logged in as an admin
    And there are several existing project options

  Scenario: Review project options 
    When I go to the project options page
    Then I see a list of all the project options
    And I see links to edit and delete them

  Scenario: Edit project option
    When I go to a project option edit page
    Then I am able to enter a description
    And I am able to enter incremental periods

  Scenario: Update project option
    Given I have entered valid information on a project option
    When I submit the "update" form
    Then I see "Project Options"
    And I see the updated information

  Scenario: Delete project option
    Given I am on the project options page
    When I delete the first project option
    Then I see "Project Options"
    And I do not see the deleted option

  Scenario: Add a project option
    Given I am on the project options page
    When I follow "Add New Project Option"
    And I enter project option details with description "New One"
    And I submit the "create" form
    Then I see "Project Options"
    And I see "New One"
