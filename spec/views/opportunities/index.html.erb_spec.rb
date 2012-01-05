require 'spec_helper'

describe "opportunities/index" do
  before(:each) do
    assign(:opportunities, [
      stub_model(Opportunity,
        :name => "Name",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zipcode => "Zipcode"
      ),
      stub_model(Opportunity,
        :name => "Name",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zipcode => "Zipcode"
      )
    ])
  end

  it "renders a list of opportunities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address1".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
  end
end
