Feature: Invest in a Cogster project
  As a user
  I want to invest money in a Cogster project
  So I can support local business and get a good deal on their merchandise

  Background:
    Given a business "BJ's Ribs" has an active project

  Scenario: Logged-in user may make purchase
    Given I am logged in
    When I go to the purchase page for BJ's Ribs
    Then I see how much Cogster Cash I will get over time if I make a purchase
    And I see a "Purchase" button

  Scenario: Logged-out user must log in to make purchase
    Given I am not logged in
    When I go to the purchase page for BJ's Ribs
    Then I see how much Cogster Cash I would get over time if I made a purchase
    And I do not see a "Purchase" button
    And I see a "Log In" link 

  Scenario: Make purchase
    Given I am logged in
    When I make a purchase for the "BJ's Ribs" project
    Then I should be on the account page
    And I should get an investment confirmation email
    And I should see a notice about how much Cogster Cash I have available

  Scenario: Review purchases
    Given I am logged in
    When I visit my account page
    Then I should see a list of all the purchases I have made
    And I should see links to print Cogster Cash for any current spending periods

  Scenario: Print Cogster Cash
    Given I am logged in
    And I have Cogster Cash for a business available today
    When I visit my Cogster Cash page for that business 
    Then I should see a Cogster Cash coupon
    And I should see how much money I have available
    And I should see the duration of the spending period
    And I should see what business the coupon is for
    And I should see a unique identifier for myself
    And I should see the region
    And it should come out as a pdf

