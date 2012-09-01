Feature: Starting a game
  As a player
  I want to be able to enter my name
  So I can create a new game
  And test that my name is set
  And that cards are displayed

Scenario: Startup of App
    Given I am on the Startup Screen
    Then I fill in "Name" with "Christian"
    And I touch "Start"
    Then I wait to see a navigation bar titled "Go Fish"
    Then I should see "Christian"
    Then I should see cards on the screen

  Scenario: Game Created
    Given I start a game with the name "Christian"
    Then I should see the default player names
