require 'spec_helper'

describe "regions/edit.html.erb" do
  before(:each) do
    @region = assign(:region, stub_model(Region,
      :name => "MyString",
      :fipscode => "MyString",
      :coords => "MyText"
    ))
  end

  it "renders the edit region form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => regions_path(@region), :method => "post" do
      assert_select "input#region_name", :name => "region[name]"
      assert_select "input#region_fipscode", :name => "region[fipscode]"
      assert_select "textarea#region_coords", :name => "region[coords]"
    end
  end
end
