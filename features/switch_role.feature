Feature: Switch role
  As a merchant or admin
  I want to view the site as a customer
  So I can shop like anyone else

  Background: 
    Given a business "BJ's Ribs" has an active project

  Scenario: Switch from merchant view
    Given I am logged in as a merchant
    And I have made a purchase
    When I visit my account page
    Then I see a "User View" button
    When I press "User View"
    Then I should see links to print Cogster Cash for any current spending periods
    And I see my swag rating
    But I do not see my current project
    And I see a "Merchant View" button

  Scenario: Switch from admin view
    Given I am logged in as a admin
    And I have made a purchase
    When I visit my account page
    Then I see a "User View" button
    When I press "User View"
    Then I should see links to print Cogster Cash for any current spending periods
    And I see my swag rating
    And I see a "Admin View" button

