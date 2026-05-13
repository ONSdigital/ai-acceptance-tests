Feature: /addresses/bulk

  Scenario: bulk addresses search
    Given I setup POST for bulk addresses
    And I use bulk request body fixture "bulktest.json"
    And I set parameters for bulk addresses search
      | param                | value |
      | historical           | true  |
      | limitperaddress      | 3     |
      | matchthreshold       | 10    |
    When I perform POST for bulk addresses
    And The bulk response status code should be 200
    Then The bulk response should return in 340000 milliseconds

  Scenario: bulk addresses search with alternate compact payload
    Given I setup POST for API path "/bulk"
    And I set query parameters
      | param           | value |
      | historical      | false |
      | limitperaddress | 1     |
    And I set request body to:
      """
      {"addresses": [{"id": "1", "address": "1 Wagtail Road"}, {"id": "2", "address": "PO8 9YD"}]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: bulk addresses search with compact inline payload
    Given I setup POST for API path "/bulk"
    And I set request body to:
      """
      {"addresses": [{"id": "1", "address": "10 Downing Street London SW1A 2AA"}, {"id": "2", "address": "Bristol Royal Infirmary Marlborough Street Bristol BS2 8HW"}]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty

  Scenario: bulk addresses search with compact payload and query parameters
    Given I setup POST for API path "/bulk"
    And I set query parameters
      | param           | value |
      | historical      | true  |
      | limitperaddress | 2     |
      | matchthreshold  | 10    |
    And I set request body to:
      """
      {"addresses": [{"id": "1", "address": "10 Downing Street London SW1A 2AA"}, {"id": "2", "address": "Royal Infirmary Oxford Road Manchester M13 9WL"}]}
      """
    When I perform POST request
    Then HTTP status code should be 200
    And response body should not be empty

