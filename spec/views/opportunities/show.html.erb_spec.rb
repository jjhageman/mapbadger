require 'spec_helper'

describe "opportunities/show" do
  before(:each) do
    @opportunity = assign(:opportunity, stub_model(Opportunity,
      :name => "Name",
      :address1 => "Address1",
      :address2 => "Address2",
      :city => "City",
      :state => "State",
      :zipcode => "Zipcode"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address2/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zipcode/)
  end
end
