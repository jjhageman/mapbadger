require 'spec_helper'

describe Opportunity do
  describe "csv importing" do
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

    describe "#csv_geo_import(file)" do
      it "should create records and lat/lng date for each csv address line" do
        Opportunity.csv_geo_import(@csv_upload)
      end
    end

    describe "#csv_import(file)" do
      it "should create records for each csv line" do

        expect {
          Opportunity.csv_import(@csv_upload)
        }.to change{ Opportunity.count }.from(0).to(3)
      end
    end
  end
end
