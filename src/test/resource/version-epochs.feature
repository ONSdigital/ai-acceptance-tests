Feature: metadata endpoints

  Scenario: Version endpoint returns metadata keys
    Given I setup GET for API path "/version"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty
    And response body should contain "apiVersion"
    And response body should contain "dataVersion"

  Scenario: Epochs endpoint returns epoch metadata
    Given I setup GET for API path "/epochs"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty
    And response body should contain "epoch"
