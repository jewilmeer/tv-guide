Feature: Authentication
  As a visor
  In order to get personalized control of the website
  I want to be able to authenticate myself

Scenario: Authenticate with valid credentials
  Given I have a valid user account
  When I authenticate
  Then I want to see that I am logged in

Scenario: Authentication with invalid credentials
  Given I have a valid user account
  When I authenticate with invalid credentials
  Then I dont want to be logged in
