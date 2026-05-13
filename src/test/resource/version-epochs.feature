Feature: metadata endpoints

  Scenario: Version endpoint returns metadata keys
    Given I setup GET for API path "/version"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty
    And response body should contain "apiVersion"
    And response body should contain "dataVersion"

  Scenario: Version endpoint response contains buildNumber
    Given I setup GET for API path "/version"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "buildNumber"

  Scenario: Version endpoint response contains status
    Given I setup GET for API path "/version"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "status"

  Scenario: Epochs endpoint returns epoch metadata
    Given I setup GET for API path "/epochs"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should not be empty
    And response body should contain "epoch"

  Scenario: Epochs endpoint response contains currentEpoch
    Given I setup GET for API path "/epochs"
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "currentEpoch"

  Scenario: Epochs endpoint response contains status with code 200
    Given I setup GET for API path "/epochs"
    When I perform GET request
    Then HTTP status code should be 200
    And response json path "status.code" should be 200
    And response body should contain "status"
