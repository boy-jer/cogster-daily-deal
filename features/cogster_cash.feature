Feature: Cogster cash
  As a user
  I want to get my Cogster cash
  So I can buy things from the merchant whose project I supported

  Background:
    Given a business "BJ's" has an active project
    And I am logged in
    And I have made a purchase
    And a clear email queue

  Scenario: Cogster cash about to expire
    Given some of my Cogster cash for the period has not been redeemed
    When the first redemption period for the project is two days from expiration
    Then I get an email reminder
    When I open the email
    Then the email says how much Cogster cash I have available for the redemption period
    And the email says which business created the project
    And the email says when the Cogster cash will expire

  Scenario: Cogster cash expires
    Given the first redemption period for the project has expired
    When I go to the account page
    Then I see the Cogster cash available for the second and subsequent redemption periods
    And I see the Cogster cash for the first redemption period has expired

  Scenario: All Cogster cash redeemed
    Given all the Cogster cash for the first redemption period has been redeemed
    When I go to the account page
    Then I see the Cogster cash available for future redemption periods
    And I see the Cogster cash for the first redemption period has a balance 0
