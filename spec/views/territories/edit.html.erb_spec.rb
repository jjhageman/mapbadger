require 'spec_helper'

describe "territories/edit.html.erb" do
  before(:each) do
    @territory = assign(:territory, stub_model(Territory,
      :name => "MyString"
    ))
  end

  it "renders the edit territory form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => territories_path(@territory), :method => "post" do
      assert_select "input#territory_name", :name => "territory[name]"
    end
  end
end
