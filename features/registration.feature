Feature: Register a new user
  In order to personalize program information
  I want to be able to create and register myself

Scenario: Register a new user
  Given I am on the registration page
  When I enter my user information
  Then I want to be logged in with the created account