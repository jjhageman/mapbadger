require 'spec_helper'

describe Opportunity do
  describe "callbacks" do
    before(:each) do
      @opportunity = Opportunity.new
    end

    describe ".lat_lng_changed_but_not_location?" do
      it "should return false when location has been changed" do
        point = Opportunity::FACTORY.point(-118.0026061167,34.1404514885).projection
        @opportunity.lat = 18
        @opportunity.location = point
        @opportunity.lat_lng_changed_but_not_location?.should be_false
      end

      it "should return true when lat or lng has changed and location has not" do
        @opportunity.lat = 18
        @opportunity.lat_lng_changed_but_not_location?.should be_true
      end
    end

    describe ".location_changed_but_not_lat_lng?" do
      it "should return true when location has been changed and lat and lng remain unchanged" do
        point = Opportunity::FACTORY.point(-118.0026061167,34.1404514885).projection
        @opportunity.location = point
        @opportunity.location_changed_but_not_lat_lng?.should be_true
      end

      it "should return false when lat or lng has changed" do
        point = Opportunity::FACTORY.point(-118.0026061167,34.1404514885).projection
        @opportunity.location = point
        @opportunity.lat = 18
        @opportunity.location_changed_but_not_lat_lng?.should be_false
      end
    end
  end

  describe "csv importing" do
    before(:each) do
      @company = FactoryGirl.create(:company)
    end

    describe "#csv_geo_import(file)" do
      before(:each) do
        @csv_geo_upload = ActionDispatch::Http::UploadedFile.new({
          :filename => 'opportunities_geo.csv',
          :type => 'text/csv',
          :head => <<-eos,
  Content-Disposition: form-data; name="upload[csv]"; filename="opportunities_geo.csv"
  Content-Type: text/csv
          eos
          :tempfile => File.new("#{Rails.root}/spec/fixtures/opportunities_geo.csv")
        })
      end

      context "CSV file missing key column(s)" do
        it "should return an error message about the missing column"
      end

      it "should create records for each csv line" do
        expect {
          Opportunity.csv_geo_import(@csv_geo_upload.read, @company)
        }.to change{ @company.opportunities.count }.from(0).to(3)
      end

      it "should create Point date for each csv address line" do
        Opportunity.csv_geo_import(@csv_geo_upload.read, @company)
        Opportunity.all.each do |o|
          o.location.should_not be_nil
        end
      end
    end

    describe "#csv_import(file)" do
      before(:each) do
        @csv_upload = ActionDispatch::Http::UploadedFile.new({
          :filename => 'opportunities.csv',
          :type => 'text/csv',
          :head => <<-eos,
  Content-Disposition: form-data; name="upload[csv]"; filename="opportunities.csv"
  Content-Type: text/csv
          eos
          :tempfile => File.new("#{Rails.root}/spec/fixtures/opportunities.csv")
        })
      end

      it "should create records for each csv line" do
        expect {
          Opportunity.csv_import(@csv_upload.read, @company)
        }.to change{ Opportunity.count }.from(0).to(3)
      end
    end
  end
end
