When /^I create multiple reps$/ do
  visit '/representatives/upload'
  fill_in 'representatives', :with => <<-ENTRY
Iris Iverson
Mary W. Walters
ENTRY
  click_button 'Add'
end

Then /^I should see the rep table$/ do
  page.should have_content 'Iris Iverson'
  page.should have_content 'Mary Walters'
end

#When /^I create a new rep$/ do
  #visit '/representatives/import'
  #fill_in 'First Name', :with => 'Iris'
  #fill_in 'Last Name', :with => 'Iverson'
  #click_button 'Add'
#end

#Then /^I should see the rep's details$/ do
  #page.should have_content 'Iris'
  #page.should have_content 'Iverson'
#end

#When /^I upload a rep CSV file$/ do
  #visit '/import'
  #click_link 'Teams'
  #attach_file 'upload_csv', 'spec/fixtures/reps.csv'
  #click_button 'Import'
#end

#Then /^I should see the rep CSV data table$/ do
  #CSV.foreach('spec/fixtures/reps.csv') do |row|
    #page.should have_content(row[0])
  #end
#end
