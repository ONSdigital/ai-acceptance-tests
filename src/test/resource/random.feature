Feature: /addresses/random

  Scenario: Random address search
    Given I setup GET for random address
    And I set parameters for random address search
      | param                | value |
      | limit                | 1     |
      | verbose              | true  |
      | eboost               | 1     |
      | nboost               | 1     |
      | sboost               | 1     |
      | wboost               | 1     |
    When I perform GET for random address
    Then The random response should contain 1 address

  Scenario: Random address search for more than 1 address
    Given I setup GET for random address
    And I set parameters for random address search
      | param                | value |
      | limit                | 100   |
      | verbose              | true  |
      | eboost               | 1     |
      | nboost               | 1     |
      | sboost               | 1     |
      | wboost               | 1     |
    When I perform GET for random address
    Then The random response should contain 100 address

  Scenario: Random address search with Scottish boost
    Given I setup GET for random address
    And I set parameters for random address search
      | param   | value |
      | limit   | 1     |
      | verbose | true  |
      | eboost  | 0     |
      | nboost  | 0     |
      | sboost  | 10    |
      | wboost  | 0     |
    When I perform GET for random address
    Then the first 1 random addresses should have countryCode "S"
