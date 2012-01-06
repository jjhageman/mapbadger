Given /^a logged in user$/ do
  # nothing for now
end

When /^I upload an opportunity CSV file$/ do
  visit '/opportunities/import'
  attach_file 'CSV File', 'spec/fixtures/opportunities.csv'
  click_button 'Import'
end

Then /^I should see the CSV data table$/ do
  pending # express the regexp above with the code you wish you had
end
