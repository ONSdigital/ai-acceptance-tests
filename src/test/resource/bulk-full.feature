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
    Then The bulk response should return in 340000 milliseconds
    And HTTP status code should be 200
    And response body should not be empty

  Scenario: Bulk full search with malformed JSON returns bad request
    Given I setup POST for API path "/bulk-full"
    And I set request body to:
      """
      [{"id":"1","address":"1 Wagtail Road"}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response body should contain "status"

