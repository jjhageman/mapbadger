Given /^a logged in user$/ do
  # nothing for now
end

When /^I upload an opportunity CSV file$/ do
  visit('/opportunities/import') 
end

Then /^I should see the CSV data table$/ do
  pending # express the regexp above with the code you wish you had
end
