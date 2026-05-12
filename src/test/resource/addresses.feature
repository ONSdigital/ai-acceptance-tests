Feature: /addresses

  Scenario: Address search Synonyms
    Given I setup GET for address
    And I set parameters for address search
      | param  | value        |
      | input  | 1 Wagtail Rd |
      | limit  | 200          |
      | nboost | 1            |
      | eboost | 1            |
      | sboost | 1            |
      | wboost | 1            |
    When I perform GET for address
    Then The first address should contain "1 Wagtail Road"
    # TODO repeat for all synonyms

  Scenario: Address search synonyms lower case
    Given I setup GET for address
    And I set parameters for address search
      | param  | value        |
      | input  | 1 wagtail rd |
      | limit  | 200          |
      | nboost | 1            |
      | eboost | 1            |
      | sboost | 1            |
      | wboost | 1            |
    When I perform GET for address
    Then The first address should contain "1 Wagtail Road"

  Scenario: Address search lower case input
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | wagtail road |
      | limit | 200          |
    When I perform GET for address
    Then The results should include an address which contains "Wagtail Road"
    And Verify Address Response body contents matched with expected values
      | key     | value   |
      | code    | 200     |
      | message | Ok      |

  Scenario: Address search with historical flag
    Given I setup GET for address
    And I set parameters for address search
      | param      | value        |
      | input      | Wagtail Road |
      | limit      | 200          |
      | historical | true         |
    When I perform GET for address
    Then The results should include an address which contains "Wagtail Road"
    And Verify Address Response body contents matched with expected values
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: Address search with pafdefault flag
    Given I setup GET for address
    And I set parameters for address search
      | param      | value        |
      | input      | Wagtail Road |
      | limit      | 200          |
      | pafdefault | true         |
    When I perform GET for address
    Then The results should include an address which contains "Wagtail Road"
    And Verify Address Response body contents matched with expected values
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: Address search with country boosts
    Given I setup GET for address
    And I set parameters for address search
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 200          |
      | nboost | 0            |
      | eboost | 1            |
      | sboost | 1            |
      | wboost | 1            |
    When I perform GET for address
    Then The results should include an address which contains "Wagtail Road"
    And Verify Address Response body contents matched with expected values
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: Address Search no filter
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | Sarah Robinson House |
      | limit                | 200                  |
    When I perform GET for address
    Then The results should include an address which contains "Parking Space"
    And The results should include an address with any of these classification codes
      | RC   |
      | RC01 |
      | PS   |
  # RC = Car Park Space and RC01 = Allocated Parking, PS = Street Record

  Scenario: Address search without input returns bad request
    Given I setup GET for address
    And I set parameters for address search
      | param | value |
      | limit | 200   |
    When I perform GET for address
    Then Verify Address Response body contents matched with expected values
      | key     | value       |
      | code    | 400         |
      | message | Missing parameter: input |

  Scenario: Address search with blank input returns bad request
    Given I setup GET for address
    And I set parameters for address search
      | param | value |
      | input |       |
      | limit | 200   |
    When I perform GET for address
    Then Verify Address Response body contents matched with expected values
      | key     | value       |
      | code    | 400         |
      | message | Bad request |

  Scenario: Address search with non numeric limit returns bad request
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | Wagtail Road |
      | limit | abc          |
    When I perform GET for address
    Then Verify Address Response body contents matched with expected values
      | key     | value       |
      | code    | 400         |
      | message | Bad request |

  Scenario: Address search with negative limit returns bad request
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | Wagtail Road |
      | limit | -1           |
    When I perform GET for address
    Then Verify Address Response body contents matched with expected values
      | key     | value       |
      | code    | 400         |
      | message | Bad request |

  Scenario: Address Search Residential filter
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | Sarah Robinson House |
      | limit                | 200                  |
      | classificationfilter | residential          |
    When I perform GET for address
    Then The results should not include an address which contains "Parking Space"
    And The results should not include any of these classification codes
      | RC   |
      | RC01 |
      | PS   |
    And The results should not include any of these classification codes
      | CC11   |
      | CR11   |
      | CT02   |
      | CT09   |
      | CT09CL |

  Scenario: Address Search with Residential filter2
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | William Hill         |
      | limit                | 200                  |
      | classificationfilter | residential          |
    When I perform GET for address
    Then The results should not include an address which contains "William Hill, William Hill Bookmakers"

  Scenario: Address search
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | Wagtail Road |
      | limit | 200          |
    When I perform GET for address
    Then the address search results should contain these UPRNs at positions
      | index | uprn         |
      | 1     | 64012390     |
      | 2     | 64012391     |
      | 3     | 64012392     |
    And Verify Address Response body contents matched with expected values
      | key     | value                            |
      | code    | 200                              |
      | message | Ok                               |

  Scenario: Historical - Postcode has changed
    Given I setup GET for address
    And I set parameters for address search
      | param    | value    |
      | input    | AB12 9FH |
      | limit    | 200      |
      | historical | true   |
      # AB12 9FH terminated in April 2019, need to find its new postcode, maybe AB12 3JG
    When I perform GET for address
   # Then The first address should contain "AB12 9FH"
    #will the results have the old postcode or new postcode?
    Then the address search results should contain these UPRNs at positions
      | index | uprn     |
      | 1     | 61000030 |

  # need the postcode of a residence which no longer exists
  Scenario: Historical - Address no longer exists
    Given I setup GET for address
    And I set parameters for address search
      | param    | value    |
      | input    | AB12 9FH |
      | limit    | 200      |
      | historical | true   |
      # AB12 9FH terminated in April 2019, need to find its new postcode, maybe AB12 3JG
    When I perform GET for address
    Then the address search results should contain these UPRNs at positions
      | index | uprn     |
      | 1     | 61000030 |

  Scenario: Address search pagination with offset zero
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | 0            |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"

  Scenario: Address search pagination with non zero offset
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | 10           |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"

  Scenario: Address search with non numeric offset returns bad request
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | abc          |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address search with negative offset returns bad request
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param  | value        |
      | input  | Wagtail Road |
      | limit  | 10           |
      | offset | -1           |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address geospatial search with valid coordinates
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param   | value        |
      | input   | Wagtail Road |
      | limit   | 10           |
      | lat     | 51.51279     |
      | lon     | -0.09184     |
      | rangekm | 10           |
    When I perform GET request
    Then HTTP status code should be 200
    And response body should contain "addresses"

  Scenario: Address geospatial search with non numeric latitude returns bad request
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param   | value        |
      | input   | Wagtail Road |
      | limit   | 10           |
      | lat     | not-a-number |
      | lon     | -0.09184     |
      | rangekm | 10           |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address geospatial search with non numeric longitude returns bad request
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param   | value        |
      | input   | Wagtail Road |
      | limit   | 10           |
      | lat     | 51.51279     |
      | lon     | not-a-number |
      | rangekm | 10           |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Address geospatial search with non numeric range returns bad request
    Given I setup GET for API path "/addresses"
    And I set query parameters
      | param   | value        |
      | input   | Wagtail Road |
      | limit   | 10           |
      | lat     | 51.51279     |
      | lon     | -0.09184     |
      | rangekm | abc          |
    When I perform GET request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  ##################

