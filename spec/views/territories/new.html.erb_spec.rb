require 'spec_helper'

describe "territories/new.html.erb" do
  before(:each) do
    assign(:territory, stub_model(Territory,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new territory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => territories_path, :method => "post" do
      assert_select "input#territory_name", :name => "territory[name]"
    end
  end
end
