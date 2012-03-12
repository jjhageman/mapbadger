require 'spec_helper'

describe Representative do
  describe "#csv_import" do
    it "should create records for each csv line" do
      csv_upload = ActionDispatch::Http::UploadedFile.new({
        :filename => 'reps.csv',
        :type => 'text/csv',
        :head => <<-eos,
Content-Disposition: form-data; name="upload[csv]"; filename="reps.csv"
Content-Type: text/csv
eos
        :tempfile => File.new("#{Rails.root}/spec/fixtures/reps.csv")
      })

      @company = Factory(:company)

      expect {
        Representative.csv_import(csv_upload.read, @company)
      }.to change{ Representative.count }.from(0).to(3)
    end
  end
end
