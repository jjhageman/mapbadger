require 'spec_helper'

describe RepresentativesController do

  before(:each) do
    @company = FactoryGirl.create(:company)
    sign_in @company
  end

  describe "POST upload" do
    it "should create a new representative for each line of text entered" do
      expect {
        post :upload, :representatives => "First1 Last1\r\nFirst2 Last2\r\nFirst3 Last3\r\n"
      }.to change(Representative, :count).by(3)
    end
    
    it "should handle empty lines properly" do
      expect {
        post :upload, :representatives => "First1 Last1\r\n\r\nFirst3 Last3\r\n"
      }.to change(Representative, :count).by(2)
    end

    it "should ignore middle names and initials" do
      post :upload, :representatives => "First Middle Last"
      rep = assigns[:current_company].representatives.first
      rep.first_name.should == 'First'
      rep.last_name.should == 'Last'
    end

    it "should handle first names only" do
      post :upload, :representatives => "First"
      rep = assigns[:current_company].representatives.first
      rep.first_name.should == 'First'
      rep.last_name.should be_nil
    end
  end
end
