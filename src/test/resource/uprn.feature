Feature: /addresses/uprn

  Scenario: UPRN search
    Given I setup GET for UPRN
    And I set the following parameters for UPRN
      | param | value |
      | limit | 200   |
    When I perform GET for UPRN "64012390"
    Then The result should be this postcode "PO8 9YD"
    And Verify UPRN Response body contents matched with expected values
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: UPRN search with invalid format returns bad request
    Given I setup GET for UPRN
    And I set the following parameters for UPRN
      | param | value |
      | limit | 200   |
    When I perform GET for UPRN "not-a-uprn"
    Then UPRN HTTP status code should be 400

  Scenario: UPRN search for unknown UPRN returns not found
    Given I setup GET for UPRN
    And I set the following parameters for UPRN
      | param | value |
      | limit | 200   |
    When I perform GET for UPRN "999999999999"
    Then UPRN HTTP status code should be 404
