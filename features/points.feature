Feature: Having points
  As a user
  I want to get points
  So I can feel like I'm scoring

  Scenario: Earning points
    Given I am logged in
    When I make a purchase
    Then I get points for the money I spent

  Scenario: Seeing points
    Given I have made a purchase
    When I go to my community page
    Then I should see my swag rating based on my purchases
    And I should see a change to the swag meter for the region

  Scenario: Seeing points at a business
    Given I have made a purchase
    And it is my first purchase in the project
    And I made the biggest purchase of anyone in that project
    When I go to the business page where I made the purchase
    Then I should see my name at the top of the Our Cogs list
    And I should see an increase in the number of supporters of the project

