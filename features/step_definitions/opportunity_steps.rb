When /^I create a new opportunity$/ do
  visit '/opportunities/import'
  fill_in 'Prospect Name', :with => 'Acme Anvils, Inc.'
  fill_in 'Address 1', :with => '123 Market St.'
  fill_in 'Address 2', :with => 'Ste 100'
  fill_in 'City', :with => 'San Francisco'
  select 'California', :from => 'State'
  fill_in 'Zip Code', :with => '94101'
  click_button 'Add'
end

Then /^I should see the opportunity details$/ do
  page.should have_content 'Acme Anvils, Inc.'
end

When /^I upload an opportunity CSV file$/ do
  visit '/opportunities/import'
  attach_file 'CSV File', 'spec/fixtures/opportunities.csv'
  click_button 'Import'
end

Then /^I should see the CSV data table$/ do
  CSV.foreach('spec/fixtures/opportunities.csv') do |row|
    page.should have_content(row[0])
  end
end
