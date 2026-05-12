Feature: /addresses/multiuprn

  # API expects UPRNs as strings inside the uprns array.
  Scenario: Multi UPRN search returns matching UPRNs
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param      | value |
      | historical | false |
    And I set request body to:
      """
      {"uprns":["64012390","64012391"]}
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
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with duplicate UPRNs in request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["64012390","64012390"]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should contain "64012390"

  Scenario: Multi UPRN search with empty uprns array returns success
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":[]}
      """
    When I perform POST request
    Then HTTP status code should be 200

  Scenario: Multi UPRN search with missing uprns field returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"foo":["64012390"]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with null uprns field returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":null}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with mixed valid and unknown UPRNs
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["64012390","999999999999"]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should contain "64012390"

  Scenario: Multi UPRN search with non-string UPRN values returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":[64012390,64012391]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with historical true
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param      | value |
      | historical | true  |
    And I set request body to:
      """
      {"uprns":["64012390","64012391"]}
      """
    When I perform POST request
    Then HTTP status code should be 200

  Scenario: Multi UPRN search with pafdefault true
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param      | value |
      | pafdefault | true  |
    And I set request body to:
      """
      {"uprns":["64012390","64012391"]}
      """
    When I perform POST request
    Then HTTP status code should be 200

  Scenario: Multi UPRN search with invalid epoch returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param | value      |
      | epoch | invalid123 |
    And I set request body to:
      """
      {"uprns":["64012390","64012391"]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with malformed JSON body returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["64012390","64012391"
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400

  Scenario: Multi UPRN search with whitespace UPRN returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":[" "]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Multi UPRN search with empty string UPRN returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":[""]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Multi UPRN search with mixed string and null uprns returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["64012390",null]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"

  Scenario: Multi UPRN search with unknown UPRNs only returns success
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["999999999990","999999999991"]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: Multi UPRN search with historical query as invalid text updates value to false and returns success
    Given I setup POST for API path "/addresses/multiuprn"
    And I set query parameters
      | param      | value |
      | historical | maybe |
    And I set request body to:
      """
      {"uprns":["64012390"]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response json path "status.code" should be 200
    And response body should contain "status"
    And response json path "historical" should be "false"

  Scenario: Multi UPRN search with very long UPRN string returns bad request
    Given I setup POST for API path "/addresses/multiuprn"
    And I set request body to:
      """
      {"uprns":["123456789012345678901234567890"]}
      """
    When I perform POST request
    Then HTTP status code should be 400
    And response json path "status.code" should be 400
    And response body should contain "status"