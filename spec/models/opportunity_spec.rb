require 'spec_helper'

describe Opportunity do
  describe "#csv_import(file)" do
    it "should create records for each csv line" do
      csv_upload = ActionDispatch::Http::UploadedFile.new({
        :filename => 'opportunities.csv',
        :type => 'text/csv',
        :head => <<-eos,
Content-Disposition: form-data; name="upload[csv]"; filename="opportunities.csv"
Content-Type: text/csv
eos
        :tempfile => File.new("#{Rails.root}/spec/fixtures/opportunities.csv")
      })

      expect {
        Opportunity.csv_import(csv_upload)
      }.to change{ Opportunity.count }.from(0).to(3)
    end
  end
end
