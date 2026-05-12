Feature: /addresses/partial

  Scenario: Partial address search returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | 10      |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"
    And there should be at least 1 addresses in the response

  Scenario: Partial address search in lower case returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | wagtail |
      | limit | 10      |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"
    And there should be at least 1 addresses in the response

  Scenario: Partial address search with limit 1 returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | 1       |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"
    And there should be at least 1 addresses in the response

  Scenario: Partial address search with high limit returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | 50      |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"
    And there should be at least 1 addresses in the response

  Scenario: Partial address search with country boosts returns results
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param  | value   |
      | input  | Wagtail |
      | limit  | 10      |
      | nboost | 1       |
      | eboost | 1       |
      | sboost | 1       |
      | wboost | 1       |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"
    And there should be at least 1 addresses in the response

  Scenario: Partial address search without input returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value |
      | limit | 10    |
    When I perform GET request
    Then HTTP status code should be 400

  Scenario: Partial address search with blank input returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value |
      | input |       |
      | limit | 10    |
    When I perform GET request
    Then HTTP status code should be 400

  Scenario: Partial address search with non numeric limit returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | abc     |
    When I perform GET request
    Then HTTP status code should be 400

  Scenario: Partial address search with negative limit returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value   |
      | input | Wagtail |
      | limit | -1      |
    When I perform GET request
    Then HTTP status code should be 400

  Scenario: Partial address search with invalid epoch returns bad request
    Given I setup GET for API path "/addresses/partial"
    And I set query parameters
      | param | value      |
      | input | Wagtail    |
      | limit | 10         |
      | epoch | invalid123 |
    When I perform GET request
    Then HTTP status code should be 400
