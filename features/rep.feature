Feature: Manage rep data
  In order to manage a sales team
  As a user
  I want to import and manage sales reps

  Background:
    Given I am logged in

  Scenario: Bulk import reps
    When I create multiple reps
    Then I should see the rep table

  #Scenario: Import rep CSV
    #Given I am logged in
    #When I upload a rep CSV file
    #Then I should see the rep CSV data table

  #Scenario: User adds rep
    #Given I am logged in
    #When I create a new rep
    #Then I should see the rep's details
