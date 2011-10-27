Feature:
  In order to share program information with the user
  there needs to be a good information overview

  Background:
    Given a program exists with name: "je moeder", max_season_nr: "2"

  Scenario: 'display within programs overview'
    When I go to the programs page
    Then I should see "je moeder" within "table"

  Scenario: 'show basic information on show page'
    When I go to the show page for that program
    Then I should see "je moeder" within "h1"

  Scenario: 'season tabs'
    When I go to the show page for that program
    Then there should be a "Season 1" season tab
    And there should be a "Season 2" season tab
    And there should not be a "Season 3" season tab
  
  @selenium    
  Scenario: 'too many season tabs'
    Given a program exists with name: "je vader", max_season_nr: "8"
    When I go to the show page for that program
    Then I take a screenshot
    Then there should not be a "Season 8" season tab
    And there should be a "season 8" hidden season tab 
