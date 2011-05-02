Feature: Manage redemptions
  As a merchant
  I want to keep track of Cogster cash reimbursements
  So I can allow my customers to use what they have purchased

  Scenario: View outstanding Cogster cash
    Given I am logged in as a merchant
    And I have an active project
    And a user has Cogster cash that can be reimbursed this week
    When I visit my account page
    Then I see a Cogster cash table
    And I see a row with the user's name and Cogster ID
    And I see how much Cogster cash the user has available
    When I click the amount
    Then I see a form to redeem the user's Cogster cash

  Scenario: User's first Cogster cash redemption period expires midweek
    Given I am logged in as a merchant
    And I have an active project
    And a user has Cogster cash that expires midweek
    And the user has Cogster cash that becomes available midweek
    When I visit my account page
    Then I see a Cogster cash table
    And I see a row with the user's name and Cogster ID
    And I see which days are in the user's first redemption period
    And I see which days are in the user's second redemption period

  Scenario: View all Cogster cash purchases
    Given I am logged in as a merchant
    And I have an active project
    And a user has Cogster cash that expires midweek
    And the user has Cogster cash that becomes available midweek
    When I visit my account page
    Then I see "View All Cogster Cash Purchases"
    When I click "View All Cogster Cash Purchases"
    Then I see a table of every purchase made in my active project
    And each row has the purchaser's name
    And each row has the date of purchase
    And each row has the purchase amount
    And each row has the Cogster cash outstanding for each redemption period

