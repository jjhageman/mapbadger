Feature: Manage rep data
  In order to manage a sales team
  As a user
  I want to import and manage sales reps

  Scenario: Import rep CSV
    Given a logged in user
    When I upload a rep CSV file
    Then I should see the rep CSV data table

  Scenario: User adds rep
    Given a logged in user
    When I create a new rep
    Then I should see the rep's details
