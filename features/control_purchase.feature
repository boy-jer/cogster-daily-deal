Feature: Control of purchase
  As a merchant
  I want control over how purchases are made
  So I can make the project more profitable

  Background:
    Given a business "BJ's Ribs" has an active project
    And the project has a maximum purchase of $50

  Scenario: Prevent purchase when goal has been reached
    Given the project funding is equal to the project goal
    When I go to the business page for BJ's Ribs
    Then I do not see a way to make a purchase
    And I see a message that says the project has met its goal

  Scenario: User sees what happens after making a purchase
    Given I am logged in
    And I have made a purchase
    When I go to the business page for BJ's Ribs
    Then I see my purchase reflected in the project funding
    And I see my purchase reflected in the project's number of supporters

