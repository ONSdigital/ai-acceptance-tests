Feature: /bulk-full

  Scenario: Bulk full search with minimal valid payload
    Given I setup POST for API path "/bulk-full"
    And I set query parameters
      | param           | value |
      | historical      | true  |
      | limitperaddress | 3     |
      | matchthreshold  | 10    |
    And I set request body to:
      """
      {"addresses": [{"id":"1","address":"1 Wagtail Road"}]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: Bulk full search with missing addresses key returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      [{"id":"1","address":"1 Wagtail Road"}]
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "Json validation error"
    And response body should contain "error.expected.jsobject"

  Scenario: Bulk full search with malformed JSON returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      [{"id":"1","address":"1 Wagtail Road"}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Bulk full search with empty addresses array returns success with zero bulk size
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      {"addresses":[]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response json path "bulk_size" should be 0

  Scenario: Bulk full search with missing address text returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      {"addresses":[{"id":"1"}]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Bulk full search with null address value returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      {"addresses":[{"id":"1","address":null}]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Bulk full search with non string address returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      {"addresses":[{"id":"1","address":12345}]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Bulk full search with non numeric limitperaddress returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set query parameters
      | param           | value |
      | limitperaddress | abc   |
    And I set request body to:
      """
      {"addresses":[{"id":"1","address":"1 Wagtail Road"}]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response json path "bad_request_message" should be "Limit parameter is not numeric"

  Scenario: Bulk full search with negative matchthreshold returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set query parameters
      | param          | value |
      | matchthreshold | -1    |
    And I set request body to:
      """
      {"addresses":[{"id":"1","address":"1 Wagtail Road"}]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response json path "bad_request_message" should be "MatchThreshold parameter must be greater than 0 and less than or equal to 100"

  Scenario: Bulk full search with mixed valid and invalid entries returns handled response
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      {"addresses":[{"id":"1","address":"1 Wagtail Road"},{"id":"2","address":"zzzzzz-not-an-address"}]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty



