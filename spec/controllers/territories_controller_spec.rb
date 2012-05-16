require 'spec_helper'

describe TerritoriesController do
  before(:each) do
    @company = FactoryGirl.create(:company)
    sign_in @company
  end

  def valid_attributes
    FactoryGirl.attributes_for(:territory)
  end

  describe ".adjust_zipcode_ids" do
    before(:each) do
      @territory = mock_model(Territory, :zipcode_ids => [1,2,3])
      @company.stub_chain(:territories, :find).and_return(@territory)
      Company.any_instance.stub_chain(:territories, :find).and_return(@territory)
    end

    it "should do nothing if param missing :territory or :territory_zipcodes_attributes" do
      params = {'test' => 'params'}
      @territory.should_receive(:update_attributes).with(params).and_return(true)
      put :update, :id => @territory.id, :territory => params
    end

    it "should add new zipcode ids" do
      original_params = {'name'=>'test','territory_zipcodes_attributes'=>[{'zipcode_id'=>1}, {'zipcode_id'=>2}, {'zipcode_id'=>3}, {'zipcode_id'=>4}]}
      updated_params = {'name'=>'test','territory_zipcodes_attributes'=>[{'zipcode_id'=>'4'}]}

      @territory.should_receive(:update_attributes).with(updated_params).and_return(true)
      put :update, :id => @territory.id, :territory => original_params
    end

    it "should mark deleted zipcode ids as destroy" do
      original_params = {'name'=>'test','territory_zipcodes_attributes'=>[{'zipcode_id'=>2}, {'zipcode_id'=>3}]}
      updated_params = {'name'=>'test','territory_zipcodes_attributes'=>[{'id'=>'1', '_destroy'=>'1'}]}
      controller.stub(:deleted_territory_zipcode_ids =>[1])

      @territory.should_receive(:update_attributes).with(updated_params).and_return(true)
      put :update, :id => @territory.id, :territory => original_params
    end
  end

  describe ".new_zipcode_ids" do
    it "should return the new zipcode ids" do
      territory = mock_model(Territory, :zipcode_ids => [1,2,3,4])
      zipcode_ids = [2,3,4,5]
      controller.new_zipcode_ids(territory, zipcode_ids).should == [5]
    end
  end
  
  describe ".deleted_zipcode_ids" do
    it "should return the deleted zipcode ids" do
      territory = mock_model(Territory, :zipcode_ids => [1,2,3,4])
      territory.stub_chain(:territory_zipcodes, :find_by_zipcode_id, :id).and_return(1)
      zipcode_ids = [2,3,4,5]
      controller.deleted_territory_zipcode_ids(territory, zipcode_ids).should == [1]
    end
  end

  describe ".adjust_region_ids" do
    before(:each) do
      @territory = mock_model(Territory, :region_ids => [1,2,3])
      Company.any_instance.stub_chain(:territories, :find).and_return(@territory)
    end

    it "should do nothing if param missing :territory or :territory_regions_attributes" do
      params = {'test' => 'params'}
      @territory.should_receive(:update_attributes).with(params).and_return(true)
      put :update, :id => @territory.id, :territory => params
    end

    it "should add new region ids" do
      original_params = {'name'=>'test','territory_regions_attributes'=>[{'region_id'=>1}, {'region_id'=>2}, {'region_id'=>3}, {'region_id'=>4}]}
      updated_params = {'name'=>'test','territory_regions_attributes'=>[{'region_id'=>'4'}]}

      @territory.should_receive(:update_attributes).with(updated_params).and_return(true)
      put :update, :id => @territory.id, :territory => original_params
    end

    it "should mark deleted regions ids as destroy" do
      original_params = {'name'=>'test','territory_regions_attributes'=>[{'region_id'=>2}, {'region_id'=>3}]}
      updated_params = {'name'=>'test','territory_regions_attributes'=>[{'id'=>'1', '_destroy'=>'1'}]}
      controller.stub(:deleted_territory_region_ids =>[1])

      @territory.should_receive(:update_attributes).with(updated_params).and_return(true)
      put :update, :id => @territory.id, :territory => original_params
    end
  end

  describe ".new_region_ids" do
    it "should return the new region ids" do
      territory = mock_model(Territory, :region_ids => [1,2,3,4])
      region_ids = [2,3,4,5]
      controller.new_region_ids(territory, region_ids).should == [5]
    end
  end
  
  describe ".deleted_region_ids" do
    it "should return the deleted region ids" do
      territory = mock_model(Territory, :region_ids => [1,2,3,4])
      territory.stub_chain(:territory_regions, :find_by_region_id, :id).and_return(1)
      region_ids = [2,3,4,5]
      controller.deleted_territory_region_ids(territory, region_ids).should == [1]
    end
  end

  describe "PUT update" do
    before(:each) do
      @territory = FactoryGirl.create(:territory, :company => @company)
    end

    describe "with valid params" do
      context "territory_regions_attributes" do
        it "should adjust the associated regions according to the ids in params hash" do
          region1 = FactoryGirl.create(:region)
          region2 = FactoryGirl.create(:region)
          region3 = FactoryGirl.create(:region)
          @territory.regions << [region1, region2]

          attrs = {'name'=>'test','territory_regions_attributes'=>[{'region_id'=>region2.id}, {'region_id'=>region3.id}]}
          put :update, :id => @territory.id, :territory => attrs
          assigns[:territory].regions.should == [region2,region3]
        end
      end

      it "redirects to the territory" do
        put :update, :id => @territory.id, :territory => valid_attributes
        response.should redirect_to(@territory)
      end
    end

  end
end
