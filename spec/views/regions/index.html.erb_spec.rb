require 'spec_helper'

describe "regions/index.html.erb" do
  before(:each) do
    assign(:regions, [
      stub_model(Region,
        :name => "Name",
        :fipscode => "Fipscode",
        :coords => "MyText"
      ),
      stub_model(Region,
        :name => "Name",
        :fipscode => "Fipscode",
        :coords => "MyText"
      )
    ])
  end

  it "renders a list of regions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fipscode".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
