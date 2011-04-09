Feature: Merchant page
  As a merchant
  I want to run campaigns
  So I can make money

  Scenario: See the latest campaign
    Given I have a merchant account
    When I visit my account home page
    Then I should see details of my current campaign
    And I should see a link to start a new campaign
    And I should see a link to post a deal
    And I should see a link to edit my account
    And I should see some kind of swag-to-job conversion(?)
    And I should see how much money I earned(?) or how much I contributed to projects(?)

  Scenario: Start a campaign
    Given I visit the merchant account home page
    When I click the 'Add Campaign' link
    Then (this should go directly to the 'Add Campaign' page)
    And I should see a form to describe my next campaign
