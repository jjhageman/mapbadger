require 'spec_helper'

describe Zipcode do
  describe "#region_to_mvc" do
    it "should return the mvc array for the region data" do
      # p1 = f.point(-122.43545, 37.781578).projection
      # p2 = f.point(-122.4099154, 37.7726402).projection
      # p3 = f.point(-122.4106233, 37.8016033).projection

      poly = 'POLYGON ((-13629451.949045308 4548615.894691273, -13629489.450375697 4547357.099682412, -13629568.25344323 4551436.800024035, -13629451.949045308 4548615.894691273))'
      zip = Factory(:zipcode, :name => 94102, :region => poly)
      zip.region_to_mvc.should == '[new google.maps.LatLng(37.781578, -122.43545),new google.maps.LatLng(37.7726402, -122.4099154),new google.maps.LatLng(37.8016033, -122.4106233)]'
    end
  end
end
