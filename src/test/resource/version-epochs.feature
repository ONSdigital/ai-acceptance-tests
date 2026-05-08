Feature: metadata endpoints

  Scenario: Version endpoint returns metadata
    Given I setup GET for API path "/version"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "version"

  Scenario: Epochs endpoint returns epoch metadata
    Given I setup GET for API path "/epochs"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "epoch"
