Feature: Having points
  As a user
  I want to get points
  So I can feel like I'm scoring

  Background:
    Given I am logged in
    And a business "BJ's" has an active project
    And I have made a purchase

  Scenario: Seeing points at a business
    When I go to the business page for BJ's
    Then I see my name at the top of the Our Cogs list
    And I see the number of project supporters

