Feature: Merchant pagination
  As a user
  I want to see a limited number of merchants on each page
  So I don't have to scroll too much

  Background:
    Given there are 25 merchants in the community
    And 15 of them are restaurants
    And 13 of them have the word "Pizza" in their names
    And 1 merchant from another community is a pizza restaurant

  Scenario: Basic pagination
    When I go to the community page
    Then I see 10 merchants
    When I click "2"
    Then I see the next 10 merchants
    And I see a link to the third page of merchants

  Scenario: Filter pagination
    When I go to the community page
    And I click "Restaurants"
    Then I see 10 merchants
    When I click "2"
    Then I see 5 merchants
    And I do not see a link to a third page

  Scenario: Search pagination
    When I go to the community page
    And I search for "Pizza"
    Then I see 10 merchants
    When I click "2"
    Then I see 4 merchants
    And I do not see a link to a third page

