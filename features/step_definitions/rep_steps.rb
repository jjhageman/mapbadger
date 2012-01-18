When /^I create a new rep$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the rep's details$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I upload a rep CSV file$/ do
  visit '/import'
  click_link 'Team'
  attach_file 'CSV File', 'spec/fixtures/reps.csv'
  click_button 'Import'
end

Then /^I should see the rep CSV data table$/ do
  pending # express the regexp above with the code you wish you had
end
