Feature: Manage redemptions
  As a merchant
  I want to keep track of Cogster cash reimbursements
  So I can allow my customers to use what they have purchased

  Background: 
    Given I am a merchant with an active project

  Scenario: View outstanding Cogster cash
    Given a user has Cogster cash that can be reimbursed this week
    And I am a fucking merchant
    When I visit my account page
    Then I see a Cogster cash table
    And I see a row with the user's name and Cogster ID
    And I see how much Cogster cash the user has available
    When I click the amount
    Then I see a form to redeem the user's Cogster cash

  Scenario: View all Cogster cash purchases
    Given a user has Cogster cash that can be reimbursed this week
    And I am a fucking merchant
    When I visit my account page
    Then I see "Download Customer List"
    When I click the pdf link "Download Customer List"
    Then I see a table of every purchase made in my active project
    And each row has the purchaser's name
    And each row has the date of purchase
    And each row has the purchase amount
    And each row has the Cogster cash value for each redemption period

