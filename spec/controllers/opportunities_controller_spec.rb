require 'spec_helper'

describe OpportunitiesController do
  before(:each) do
    @company = FactoryGirl.create(:company)
    sign_in @company
  end

  describe "POST upload" do
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

      @csv_attrs = {:csv => {:file => @csv_geo_upload}}
    end

    it "should send an upload alert email" do
      csv = double 'csv'
      csv.stub(:save).and_return(true)
      csv.stub_chain(:file, :url).and_return(@csv_geo_upload.original_filename)
      Company.any_instance.stub_chain(:csvs, :new).and_return(csv)
      deliver = double 'deliver'
      deliver.should_receive(:deliver)
      ContactMailer.should_receive(:csv_upload_alert).with(@csv_geo_upload.original_filename).and_return(deliver)
      post :upload, @csv_attrs
    end
  end
end
