Feature: Invest in a business
  As a user
  I want to invest in a business
  So I can support local businesses and get good deals

  Scenario: Cap purchase at level set by merchant
    Given I am a user who wants to invest in a project
    And the project has a maximum purchase of $50
    When I visit the project page
    Then I see a select box for my purchase amount with options from $10 to $50

  Scenario: Cap purchase when project is close to goal
    Given I am a user who wants to invest in a project
    And the project has a maximum purchase of $50
    And the project funding is $20 less than the project goal
    When I visit the project page
    Then I see a select box for my purchase amount with options from $10 to $20

  Scenario: Prevent purchase when goal has been reached
    Given I am a user who wants to invest in a project
    And the project funding is equal to the project goal
    When I visit the project page
    Then I do not see a way to make a purchase
    And I see a message that says the project has met its goal

  Scenario: User sees what happens after making a purchase
    Given I have invested in a project
    Then I get an email thanking me for my purchase
    When I visit the home page
    Then I see my swag rating has increased
    And I see a table showing how much Cogster cash I can get over time
    And I see a link to get Cogster cash for the project right now
    When I visit the business page
    Then I see my purchase reflected in the project funding
    And I see my purchase reflected in the project's number of supporters

  Scenario: User makes a second investment in one project
    Given I have made a second investment in a project
    Then I get an email thanking me for my purchase
    When I visit the home page
    Then I see my swag rating has increased
    And I see a table showing how much Cogster cash I can get over time
    And I see links to get Cogster cash for each of my purchases right now
    When I visit the business page
    Then I see both of my purchases reflected in the project funding
    And I see one of my purchases reflected in the project's number of supporters

