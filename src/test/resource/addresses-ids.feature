Feature: /addresses/ids

  Scenario: Address ids search with valid input
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value        |
      | input | Wagtail Road |
      | limit | 10           |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: Address ids search without input returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value |
      | limit | 10    |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with non numeric limit returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value        |
      | input | Wagtail Road |
      | limit | abc          |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with negative offset returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | -1           |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with empty input returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value |
      | input |       |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with whitespace input returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value |
      | input |       |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with zero limit returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value        |
      | input | Wagtail Road |
      | limit | 0            |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with negative limit returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param | value        |
      | input | Wagtail Road |
      | limit | -1           |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with non numeric offset returns bad request
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | abc          |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address ids search with large offset returns handled response
    Given I setup GET for API path "/addresses/ids"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | 99999        |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response json path "errors[0].message" should be "Offset parameter is too large"
