Feature: /addresses/bulk

  Scenario: bulk addresses search
    Given I setup POST for bulk addresses
    And I set parameters for bulk addresses search
      | param                | value |
      | historical           | true  |
      | limitperaddress      | 3     |
      | epoch                | 101   |
      | matchthreshold       | 10    |
    When I perform POST for bulk addresses
    Then The bulk response should return in 340000 milliseconds
