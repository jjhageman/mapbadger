Feature: Manage opportunity data
  In order to manage a sales team
  As a user
  I want to import and manage sales opportunities

  Scenario: User adds opportunity
    Given I am logged in
    When I create a new opportunity
    Then I should see the opportunity details

  Scenario: Upload CSV file
    Given I am logged in
    When I upload an opportunity CSV file
    Then I should see the confirmation message
    And admin should receive a csv alert email
    When the admin responds to the csv alert email
    Then the admin should see the imported opportunity records
    When the admin sends the notification email
    Then I should receive a csv processed alert email

  Scenario: Advanced import opportunity CSV
    Given I am logged in
    When I advanced upload an opportunity CSV file
    Then I should see the CSV data table
