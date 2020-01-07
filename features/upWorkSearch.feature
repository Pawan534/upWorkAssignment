Feature: Upwork search features test case

  @testUpwork
  Scenario: Verify the search result content when user pass the keyword
    Given I visit the upwork home page
    And I focus on Find freelancers
    When I search the result:
      | keyword |
      | Sales   |
    And I get all the details displayed on the page
    And I click on any random freelancers user profile
    Then I verify all the user details captured in previous page

