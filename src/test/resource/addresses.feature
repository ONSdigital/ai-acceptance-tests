Feature: Search by Address Features

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
    Then The results should not include an address which contains "Bookmakers"
    # just need to find a better test

  Scenario: Address search
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | Wagtail Road |
      | limit | 200          |
    When I perform GET for address
    Then The results should include these UPRNs at positions
      | index | uprn         |
      | 1     | 64012390 |
      | 2     | 64012391 |
      | 3     | 64012392 |
    And Verify Address Response body contents matched with expected values
      | key     | value                            |
      | code    | 200                              |
      | message | Ok                               |

  Scenario: Historic Address
    Given I setup GET for address
    And I set parameters for address search
      | param | value        |
      | input | 28 SO2 7BR |
      | limit | 200          |
    |historic |true        |
    When I perform GET for address
    Then The first address should contain "SO2 7BR"
    Then The results should include these UPRNs at positions
      | index | uprn         |
      | 1     | 64012390 |
  # what postcode should be shown? - SO2 7BR or SO19 7BR?

#  Scenario
#    Then I should be able to see the first 10 addresses
#      | field            | value          |
#      | formattedAddress | Merrivale Road |
#      | countryCode      | E              |
#    Then I should be able to see the list of uprns in the address
#      | index | uprn       |
#      | 1     | 40028973   |
#      | 2     | 32142632   |
#      | 3     | 1775055324 |
#    And Verify Address Response body contents matched with expected values
#      | key     | value |
#      | code    | 200   |
#      | message | Ok    |
