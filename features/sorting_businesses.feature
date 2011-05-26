Feature: Sorting Businesses
  As a user
  I want to choose how to sort businesses
  So I can focus on the ones I'm interested in

  Background: Populated community
    Given the following businesses:
    | Name	             | Community	| Featured	| Type	| Funded	| Goal |
    | BJ's	             | Grove		  |           | food	|  80     | 100  |
    | DJ Pizza	         | Grove	    | true      | food	|  70     | 100  |
    | College Pizza	     | State Col  | true      | food	|  90	    | 200  |
    | Massage	           | State Col  |           | etc	  |  50	    |  50  |
    | Tastee Freeze	     | Grove		  |           | food	|   0	    |  50  |
    | Fortune Teller	   | Grove	    |           | etc	  |  15	    | 100  |
    | Larry's Pizza	     | Grove		  |           | food	| 100	    | 100  |
    | Danville Pizza	   | Danville		|           | food	|  50	    |  50  |
    | Haberdasher	       | Grove		  |           | cloth |	 75	    | 100  |
    | SpacePort	         | Grove		  |           | game	|  50	    | 100  |
    | Library	           | Sunbury		|           | game	|  50	    | 100  |
    | College Video Game | State Col  |           | game	|  55	    | 100  |
    | Milton Pizza	     | Milton	    | true      | food	|   0     | 	0  |
    | Lunch Lady Pizza	 | Grove		  |           | food	|  10	    | 100  |
    | Brookside	         | Grove		  |           | etc	  |  30	    | 999  |
    | Minigolf	         | Grove		  |           | golf	|   0	    |  20  |
    | Country Club	     | Grove		  |           | golf	|  50	    | 200  |
    | 9 hole	           | Grove		  |           | golf	|  20	    | 100  |
    | Sunbury Golf	     | Sunbury		|           | golf	|   0	    | 100  |
    | Sunbury Fashion	   | Sunbury		|           | cloth |  20	    | 100  |
    | Peppermint Lounge	 | Sunbury	  | true      | food	|  30	    |  50  |
    | Squeeze In	       | Sunbury		|           | food	|   1	    |   5  |
    | White Mountain	   | Grove		  |           | food	|  20	    |  40  |

  Scenario: Default ordering
    When I go to the community page for Grove
    Then it all works
    And I see 10 merchants
    And the merchant in position 1 is DJ Pizza
    And the merchant in position 2 is Larry's Pizza
    And the merchant in position 10 is Lunch Lady Pizza
    When I click "2"
    Then I see 3 merchants
    And the merchant in position 1 is Brookside

  Scenario: Filtering
    When I go to the community page for Grove
    And I click "etc"
    Then I see 2 merchants
    And the merchant in position 1 is Fortune Teller
    And the merchant in position 2 is Brookside
    When I click "Name (A-Z)"
    Then I see 2 merchants
    And the merchant in position 1 is Brookside
    And the merchant in position 2 is Fortune Teller

  Scenario: Order by newest
    When I go to the community page for Grove
    And I click "Newest"
    Then I see 10 merchants
    And the merchant in position 1 is White Mountain
    And the merchant in position 10 is Fortune Teller
    When I click "2"
    Then I see 3 merchants
    And the merchant in position 1 is Tastee Freeze
    And the merchant in position 3 is BJ's

  Scenario: Search as logged in user
    When I register 
    Then I should be a Grove person
    When I log in
    And I go to the community page for Grove
    And I search for "pizza"
    Then I see 6 merchants
    And show me the page
