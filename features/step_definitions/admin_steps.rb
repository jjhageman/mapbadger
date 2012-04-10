def create_admin
  @admin ||= Factory(:company, email: 'admin@mapbadger.com', :role => 'admin')
end

def admin_sign_in
  visit '/login'
  fill_in 'Email', :with => @admin.email
  fill_in 'Password', :with => 'please'
  click_button 'Sign in'
end

Given /^I am a logged in admin$/ do
  create_admin
  admin_sign_in
end
