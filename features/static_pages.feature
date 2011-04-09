Feature: Static pages
  As a user
  I want to read some of the boilerplate
  So I can know whether I can sue you 

  Scenario: Visit pages
    Given I go to the home page
    When I click the faq link
    And I click the Terms of Use link
    And I click the Privacy Policy link
    And I click the contact link
    Then I should see the faq page
    And I should see the Terms of Use page
    And I should see the Privacy Policy page
    And I should see the contact form 

  Scenario: Visit interior pages
    Given I log in 
    When I click the How it Works link
    And I click the Local link
    And I click the Swag link
    Then I should see the How it Works page
    And I should see the Local page
    And I should see the Swag page
