Feature: Address Index features
 Scenario: Uprn search
   Given I perform get operation for uprn  "/uprn"
   And I perform GET for uprn "98"
   Then I should be able to see the list of addresses in the given uprn
   And Verify Response body contents matched with expected values
     | key     | value                            |
     | code    | 200                              |
     | message | Ok                               |

  Scenario: Postcode search
    Given I perform get operation for postcode "/postcode"
    And I perform GET for postcode "KL37GQ"
    Then I should be able to see the list of addresses in the postcode
    And Verify Response body contents matched with expected values
      | key     | value                            |
      | code    | 200                              |
      | message | Ok                               |