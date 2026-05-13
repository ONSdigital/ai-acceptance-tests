Feature: /addresses/random

  Scenario: Random address search
    Given I setup GET for random address
    And I set parameters for random address search
      | param                | value |
      | limit                | 1     |
      | verbose              | true  |
      | eboost               | 1     |
      | nboost               | 1     |
      | sboost               | 1     |
      | wboost               | 1     |
    When I perform GET for random address
    Then The random response should contain 1 address

  Scenario: Random address search for more than 1 address
    Given I setup GET for random address
    And I set parameters for random address search
      | param                | value |
      | limit                | 100   |
      | verbose              | true  |
      | eboost               | 1     |
      | nboost               | 1     |
      | sboost               | 1     |
      | wboost               | 1     |
    When I perform GET for random address
    Then The random response should contain 100 address

  Scenario: Random address search with Scottish boost
    Given I setup GET for random address
    And I set parameters for random address search
      | param   | value |
      | limit   | 1     |
      | verbose | true  |
      | eboost  | 0     |
      | nboost  | 0     |
      | sboost  | 10    |
      | wboost  | 0     |
    When I perform GET for random address
    Then the first 1 random addresses should have countryCode "S"

  Scenario: Random address search with zero limit returns bad request
    Given I setup GET for API path "/addresses/random"
    And I set query parameters
      | param | value |
      | limit | 0     |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Random address search with negative limit returns bad request
    Given I setup GET for API path "/addresses/random"
    And I set query parameters
      | param | value |
      | limit | -1    |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Random address search with non numeric limit returns bad request
    Given I setup GET for API path "/addresses/random"
    And I set query parameters
      | param | value |
      | limit | abc   |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Random address search with historical true returns results
    Given I setup GET for API path "/addresses/random"
    And I set query parameters
      | param      | value |
      | limit      | 1     |
      | historical | true  |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: Random address search with classificationfilter residential returns results
    Given I setup GET for API path "/addresses/random"
    And I set query parameters
      | param                | value       |
      | limit                | 1           |
      | classificationfilter | residential |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty
