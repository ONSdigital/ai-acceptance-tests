Feature: addresses/postcode

  Scenario: 1. Standard Postcode search
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "PO8 9YD"
    Then the postcode results should contain all these UPRNs in any address
      | 100060291782 |
      | 100060291783 |
      | 100060291784 |
#    # or should we check that the formatted address contains PO8 9YD
#    #Then the results should all have formattedAddress includes "PO8 9YD"
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1. Standard Postcode search lower case
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "po8 9yd"
    Then the postcode results should contain these UPRNs at positions
      | index | uprn         |
      | 1     | 100060291782 |
      | 2     | 100060291783 |
      | 3     | 100060291784 |
    # or should we check that the formatted address contains PO8 9YD
    #Then the results should all have formattedAddress includes "PO8 9YD"
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.1: Postcode search with missing space
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "PO89YD"
    Then the postcode results should contain these UPRNs at positions
      | index | uprn         |
      | 1     | 100060291782 |
      | 2     | 100060291783 |
      | 3     | 100060291784 |
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.2: Postcode search with wrong space
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "PO89 YD"
    And Verify postcode response status
      | key     | value       |
      | code    | 400         |
      | message | Bad request |

  Scenario: 1.3: Postcode search with additional letter
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "PO8 9YDB"
    And Verify postcode response status
      | key     | value       |
      | code    | 400         |
      | message | Bad request |

  Scenario: 1.3: Postcode search with number instead of letter
    Given the user defines GET for postcode with these parameters
      | param  | value        |
      | limit  | 200          |
    When the user performs GET for postcode "P08 9YD"
    Then there should be 0 addresses
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.4: Postcode search with residential filter
    Given the user defines GET for postcode with these parameters
      | param                | value       |
      | classificationfilter | residential |
    When the user performs GET for postcode "GU32 3HJ"
    Then The postcode results should not include any of these classification codes
      | RC   |
      | RC01 |
      | PS   |
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.4: Postcode search with commercial filter
    Given the user defines GET for postcode with these parameters
      | param                | value       |
      | classificationfilter | residential |
    When the user performs GET for postcode "GU32 3HJ"
    Then The postcode results should not include any of these classification codes
      | RC   |
      | RC01 |
      | PS   |
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.4: Postcode search with workplace filter
    Given the user defines GET for postcode with these parameters
      | param                | value       |
      | classificationfilter | residential |
    When the user performs GET for postcode "GU32 3HJ"
    Then The postcode results should not include any of these classification codes
      | CC11  |
      | CR11 |
      | CT01   |
    # list is long so put in a list somewhere else

    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

  Scenario: 1.4: Postcode search with educational filter
    Given the user defines GET for postcode with these parameters
      | param                | value       |
      | classificationfilter | residential |
    When the user performs GET for postcode "GU32 3HJ"
    Then The postcode results should not include any of these classification codes
      | RC   |
      | RC01 |
      | PS   |
    And Verify postcode response status
      | key     | value |
      | code    | 200   |
      | message | Ok    |

    # AB12 9FH terminated in April 2019, need to find its new postcode, maybe AB12 3JG
  Scenario: Historical - Postcode has been changed
    Given the user defines GET for postcode with these parameters
      | param      | value |
      | limit      | 200   |
      | historical | true  |
    When the user performs GET for postcode "AB12 9FH"
    Then the postcode results should contain these UPRNs at positions
      | index | uprn     |
      | 1     | 99999999 |
    # what postcode should results show? - old SO2 7BR or SO19 7BR?

  # need the postcode of a residence which no longer exists
 Scenario: Historical - Address no longer exists
   Given the user defines GET for postcode with these parameters
     | param      | value |
     | limit      | 200   |
     | historical | true  |
   When the user performs GET for postcode "xxx xxx"
   Then the postcode results should contain these UPRNs at positions
     | index | uprn     |
     | 1     | 99999999 |

#   Scenario:
#     Given the user defines GET for postcode with these parameters
#       | param      | value |
#       | limit      | 200   |
#       | historical | true  |
#     When the user performs GET for postcode "SO2 7BR"
#     Then the postcode results should include these UPRNs
#   "99999999"

    # need example
  Scenario: Auxiliary Index
    Given the user defines GET for postcode with these parameters
      | param | value |
    #  | limit | 3     |
      | historical|true|
    When the user performs GET for postcode "xxx"
    Then the postcode results should not include UPRN "99999999"

  Scenario: Exclude results from all countries except N
    Given the user defines GET for postcode with these parameters
      | param  | value |
      | nboost | 1     |
      | eboost | 0     |
      | wboost | 0     |
      | sboost | 0     |
    When the user performs GET for postcode "PO8 9YD"
    Then there should be 0 addresses

  Scenario: Exclude country E for postcode with 2 addresses, one in S, one in E.
    Given the user defines GET for postcode with these parameters
      | param  | value |
      | nboost | 1     |
      | eboost | 0     |
      | wboost | 1     |
      | sboost | 1     |
    When the user performs GET for postcode "TD9 0TU"
    Then there should be 1 addresses
    Then the first 1 addresses should have countryCode "S"
    #Then the first 1 addresses should not have countryCode "E"

  Scenario: Exclude country E for postcode with 2 addresses, one in S, one in E.
    Given the user defines GET for postcode with these parameters
      | param  | value |
      | nboost | 1     |
      | eboost | 1     |
      | wboost | 1     |
      | sboost | 1     |
    When the user performs GET for postcode "PO8 9YD"
    Then there should be 38 addresses
