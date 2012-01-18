require 'spec_helper'

describe "representatives/index" do
  before(:each) do
    assign(:representatives, [
      stub_model(Representative,
        :first_name => "First Name",
        :last_name => "Last Name"
      ),
      stub_model(Representative,
        :first_name => "First Name",
        :last_name => "Last Name"
      )
    ])
  end

  it "renders a list of representatives" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
  end
end
