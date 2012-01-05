require 'spec_helper'

describe "opportunities/new" do
  before(:each) do
    assign(:opportunity, stub_model(Opportunity,
      :name => "MyString",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zipcode => "MyString"
    ).as_new_record)
  end

  it "renders new opportunity form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => opportunities_path, :method => "post" do
      assert_select "input#opportunity_name", :name => "opportunity[name]"
      assert_select "input#opportunity_address1", :name => "opportunity[address1]"
      assert_select "input#opportunity_address2", :name => "opportunity[address2]"
      assert_select "input#opportunity_city", :name => "opportunity[city]"
      assert_select "input#opportunity_state", :name => "opportunity[state]"
      assert_select "input#opportunity_zipcode", :name => "opportunity[zipcode]"
    end
  end
end
