Feature: Static pages
  As a user
  I want to read some of the boilerplate
  So I can know whether I can sue you 

  Background:
    Given a community has been created so the selection doesn't break

  Scenario: Visit pages
    Given I go to the home page
    When I click "FAQ"
    Then I see "Frequently Asked Questions"
    When I click "Terms of Use"
    Then I see "Cogster Terms of Service"
    When I click "Privacy Policy"
    Then I see "Cogster Privacy Agreement"
    When I click "Contact"
    Then I see "contact form"
    When I click "How it Works"
    Then I see "How Cogster Works"
    When I click "swag"
    Then I see "Swag"
