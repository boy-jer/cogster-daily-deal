Feature: Purchase a Cogster project
  As a user
  I want to make a purchase in a Cogster project
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
    And I just checked my email
    When I make a purchase for the "BJ's Ribs" project
    Then I am on the account page
    And I get a purchase confirmation email
    And I see a notice about how much Cogster Cash I have available

  Scenario: Make second purchase
    Given I am logged in
    When I make a purchase for the "BJ's Ribs" project
    And I go to the purchase page for BJ's Ribs
    Then I see my address

  Scenario: Review purchases
    Given I am logged in
    And I just checked my email
    When I have made a purchase
    Then I get a purchase confirmation email
    When I visit my account page
    Then I should see a list of all the purchases I have made
    And I should see links to print Cogster Cash for any current spending periods

  Scenario: Print Cogster Cash
    Given I am logged in
    And I have Cogster Cash for a business available today
    When I visit my Cogster Cash page for that business 
    Then I get a pdf
    And I see a Cogster Cash coupon
    And I see how much money I have available
    And I see the duration of the spending period
    And I see what business the coupon is for
    And I see a unique identifier for myself
    And I see the community
