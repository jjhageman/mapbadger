When /^I fill out the registration form$/ do
  visit '/register'
  fill_in 'First name', :with => 'Iris'
  fill_in 'Last name', :with => 'Iverson'
  fill_in 'Company name', :with => 'Acme Sales'
  fill_in 'Email', :with => 'iris@acme.com'
  fill_in 'Password', :with => 'secret'
  fill_in 'Password confirmation', :with => 'secret'
  click_button 'Sign up'
end

Then /^I should see an email confirmation message$/ do
  page.should have_content 'A message with a confirmation link has been sent to your email address'
end

Then /^I should receive a confirmation email$/ do
  unread_emails_for('iris@acme.com').size.should == 1
end

When /^I follow the email link$/ do
  open_last_email_for('iris@acme.com')
  click_email_link_matching /confirm/
end

Then /^my account should be confirmed$/ do
  page.should have_content 'Your account was successfully confirmed'
end

When /^I login via salesforce$/ do
  visit '/login'
  click_link ''
end
