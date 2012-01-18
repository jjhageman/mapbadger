require 'spec_helper'

describe "representatives/new" do
  before(:each) do
    assign(:representative, stub_model(Representative,
      :first_name => "MyString",
      :last_name => "MyString"
    ).as_new_record)
  end

  it "renders new representative form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => representatives_path, :method => "post" do
      assert_select "input#representative_first_name", :name => "representative[first_name]"
      assert_select "input#representative_last_name", :name => "representative[last_name]"
    end
  end
end
