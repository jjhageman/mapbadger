Feature: Manage opportunity data
  In order to manage a sales team
  As a user
  I want to import and manage sales opportunities

  Scenario: User adds opportunity
    Given a logged in user
    When I create a new opportunity
    Then I should see the opportunity details

  Scenario: Import opportunity CSV
    Given a logged in user
    When I upload an opportunity CSV file
    Then I should see the CSV data table
