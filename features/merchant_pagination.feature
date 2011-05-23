Feature: Merchant pagination
  As a user
  I want to see a limited number of merchants on each page
  So I don't have to scroll too much

  Background:
    Given there are 25 merchants in the community
    And 15 of them are restaurants
    And 11 of them have the word "Pizza" in their names
    And 1 merchant from another community is a pizza restaurant

  Scenario:
    When I visit the community page
    Then I see 10 merchants
    And I see a link to the next page of merchants
    When I click "2"
    Then I see the next 10 merchants
    And I see a link to the third page of merchants
