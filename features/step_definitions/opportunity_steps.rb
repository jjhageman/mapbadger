When /^I create a new opportunity$/ do
  visit '/opportunities/upload'
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
  visit '/opportunities/upload'
  attach_file 'csv_file', 'spec/fixtures/opportunities.csv'
  click_button 'Import'
end

Then /^I should see the confirmation message$/ do
  page.should have_content 'Your CSV file has been received. You will be notified by email when it has finished processing.'
end

When /^I advanced upload an opportunity CSV file$/ do
  visit '/opportunities/advanced'
  attach_file 'upload_csv', 'spec/fixtures/opportunities_geo.csv'
  click_button 'Import'
end

When /^I advanced upload an opportunity CSV file with a misnamed column$/ do
  visit '/opportunities/advanced'
  attach_file 'upload_csv', 'spec/fixtures/misnamed_column_opps.csv'
  click_button 'Import'
end

Then /^I should see a page to choose which column to use for the missing column$/ do
  pending
  page.should have_content "Your CSV file appears to be missing the 'Address 1' column. Please select column from your file represents the data."
end

When /^I select an alternate column$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the CSV data table$/ do
  CSV.foreach('spec/fixtures/opportunities.csv') do |row|
    page.should have_content(row[0])
  end
end

Then /^admin should receive a csv alert email$/ do
  unread_emails_for('admin@mapbadger.com').size.should == 1
  open_email('admin@mapbadger.com', :with_text => 'A new customer CSV file has been uploaded')
end

When /^the admin responds to the csv alert email$/ do
  click_link 'Logout'
  step "I am a logged in admin"
  #click_first_link_in_email
  visit_in_email(admin_opportunities_import_url(:host => 'beta.mapbadger.com'))
  select(@company.company_name, :from => 'Company')
  attach_file 'csv', 'spec/fixtures/opportunities_geo.csv'
  click_button 'Import'
end

Then /^the admin should see the imported opportunity records$/ do
  CSV.foreach('spec/fixtures/opportunities.csv') do |row|
    page.should have_content(row[0])
  end
end

When /^the admin sends the notification email$/ do
  click_button 'Notify Customer'
  page.should have_content('A notification email has been sent to the customer')
end

Then /^I should receive a csv processed alert email$/ do
  unread_emails_for(@company.email).size.should == 1
  open_email(@company.email, :with_text => 'Your CSV file has been processed')
end
