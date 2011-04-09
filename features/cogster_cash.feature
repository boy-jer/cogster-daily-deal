Feature: Print Cogster cash
  As a user
  I want to get my Cogster cash
  So I can buy things from the merchant whose project I supported

  Scenario: Get Cogster cash
    Given I have invested in a project
    When I visit the Cogster cash page for a project
    Then I see a certificate with my name
    And the certificate shows my Cogster ID
    And the certificate shows the redemption period for the Cogster cash
    And the certificate shows my region
    And the certificate shows how much Cogster cash is available

  Scenario: Cogster cash about to expire
    Given I have invested in a project
    When the first redemption period for the project is two days from expiration
    And some of my Cogster cash for the period has not been redeemed
    Then I get an email reminder
    And the email says how much Cogster cash I have available for the redemption period
    And the email says which business created the project
    And the email says when the Cogster cash will expire

  Scenario: Cogster cash expires
    Given I have invested in a project
    And the first redemption period for the project has expired
    When I visit the home page
    Then I see the Cogster cash available for the second and subsequent redemption periods
    And I see the Cogster cash for the first redemption period has expired

  Scenario: All Cogster cash redeemed
    Given I have invested in a project
    And all the Cogster cash for the first redemption period has been redeemed
    When I visit the home page
    Then I see the Cogster cash available for future redemption periods
    And I see the Cogster cash for the first redemption period has a balance 0

