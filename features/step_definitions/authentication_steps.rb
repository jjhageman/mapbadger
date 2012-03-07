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
  page.should have_content 'wenis'
end
