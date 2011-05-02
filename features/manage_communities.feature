Feature: Manage communities
  As an admin
  I want to manage Cogster communities
  So the site can grow

  Scenario: Community request
    Given someone has requested his community be added
    And I am logged in as an admin
    When I visit my account page
    Then I see a reminder of the community request
    And I see a link to evaluate the community request

  Scenario: Making a community based on a request
    Given someone has requested his community be added
    And I am logged in as an admin
    And I am on the account page
    When I follow the link to evaluate the community request
    Then I see the user's description of the community
    And I see the form to create a community
    And I see a field to mail a response to the user

  Scenario: Review Communities
    Given I am logged in as an admin
    And I want to look at the communities
    When I visit my account page
    Then I see a "Communities" link
    When I click "Communities"
    Then I see all the communities in Cogster
    And I see how many businesses are in each community
    And I see how many users are in each community
    And I see a link to edit each community
    And I see a button to delete each community
    And I see a "New Community" link

