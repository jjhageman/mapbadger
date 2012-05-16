def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "please", :password_confirmation => "please" }
end

def delete_company
  @company ||= Company.first conditions: {:email => @visitor[:email]}
  @company.destroy unless @company.nil?
end

def create_company
  create_visitor
  delete_company
  @company = FactoryGirl.create(:company, company_name: 'Acme', email: @visitor[:email])
end

def sign_in
  visit '/login'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

Given /^I am logged in$/ do
  create_company
  sign_in
end
