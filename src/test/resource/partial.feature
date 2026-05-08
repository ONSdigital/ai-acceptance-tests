Feature: /addresses/partial

  Scenario: Partial address search returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | 10      |
    When I perform GET request
    Then HTTP status code should be 200
    And there should be at least 1 addresses in the response

  Scenario: Partial address search without input returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value |
      | limit | 10    |
    When I perform GET request
    Then HTTP status code should be 400
