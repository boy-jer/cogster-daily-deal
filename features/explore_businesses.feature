Feature: See businesses in a community
  As a user
  I want to see what businesses are active in a community
  So I can shop for projects

  Scenario: View community
    Given there are several businesses active in a community
    When I visit the community page
    Then I should see the profiles of the businesses in the community
    And I should see links to the project pages for each business

  Scenario: Search for a merchant
    Given there is a business named "Joe's Ribs"
    When I search for "Joe"
    Then I should see the profile for "Joe's Ribs"

  Scenario: Filter merchants
    Given there are restaurants and shops in a community
    When I visit the community page
    And I click "Restaurants"
    Then I should see the profiles for the restaurants
    And I should not see the profiles for the shops

  Scenario: Sort merchants
    Given there are restaurants and shops in a community
    When I visit the community page 
    And I click "A-Z"
    Then I should see the profiles of the community businesses in alphabetical order

