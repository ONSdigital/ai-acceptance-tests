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