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

  Scenario: Address Search Residential filter
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | Sarah Robinson House |
      | limit                | 200                  |
      | classificationfilter | residential          |
    When I perform GET for address
    Then The results should not include an address which contains "Parking Space"
    Then The results should not include any of these classification codes
      | RC   |
      | RC01 |
      | PS   |

  Scenario: Address Search with Residential filter
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | Sarah Robinson House |
      | limit                | 200                  |
      | classificationfilter | residential          |
    When I perform GET for address
    Then The results should not include any of these classification codes
      | CC11   |
      | CR11   |
      | CT02   |
      | CT09   |
      | CT09CL |

  Scenario: Address Search with Residential filter2
    Given I setup GET for address
    And I set parameters for address search
      | param                | value                |
      | input                | William Hill |
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
      | 1     | 100110577188 |
      | 2     | 64012390 |
      | 3     | 64012391 |
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
      | historic | true     |
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
      | historic | true     |
      # AB12 9FH terminated in April 2019, need to find its new postcode, maybe AB12 3JG
    When I perform GET for address
    Then the address search results should contain these UPRNs at positions
      | 1     | 64012390 |

  ##################

