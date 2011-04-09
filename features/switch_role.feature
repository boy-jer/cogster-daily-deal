Feature: Switch role
  As a merchant or admin
  I want to view the site as a customer
  So I can shop like anyone else

  Scenario: Switch to customer view
    Given I am logged in as a merchant
    When I visit the home page
    Then I see a "Switch to Customer View" link
    When I click "Switch to Customer"
    Then I see my available Cogster cash
    And I see my swag rating
    But I do not see my current project
    And I see a "Return to Merchant View" link

