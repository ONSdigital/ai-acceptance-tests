Feature: /addresses/multiuprn

  Scenario: Multi UPRN search returns matching UPRNs
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param      | value |
      | historical | false |
    And I set request body to:
      """
      {"uprns":[64012390,64012391]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should contain "64012390"
    And response body should contain "64012391"

  Scenario: Multi UPRN search with malformed payload returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":"64012390"}
      """
    When I perform POST request
    Then HTTP status code should be 400
