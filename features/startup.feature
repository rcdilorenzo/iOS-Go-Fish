Feature: Starting a game
  As a player
  I want to be able to identify myself at the beginning of a game

Scenario: Startup of App
    Given I am on the Startup Screen
    When I fill in "Player Name" with "Christian"
    And I touch "Start"
    Then I see Christian's game in its initial state

  Scenario: Game Created
    Given I start a game with the name "Christian"
    Then I should see the default player names: Rack, Shack, Benny
