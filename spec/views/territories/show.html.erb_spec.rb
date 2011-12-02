require 'spec_helper'

describe "territories/show.html.erb" do
  before(:each) do
    @territory = assign(:territory, stub_model(Territory,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
