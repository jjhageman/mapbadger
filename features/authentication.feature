Feature: User/Company authentication
  In order to manage a sales team
  As a user
  I want to register and login to my account

  Scenario: User registration
    When I fill out the registration form
    Then I should see an email confirmation message
    And I should receive a confirmation email
    When I follow the email link
    Then my account should be confirmed
