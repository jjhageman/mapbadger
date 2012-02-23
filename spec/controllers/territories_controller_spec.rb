require 'spec_helper'

describe TerritoriesController do

  # This should return the minimal set of attributes required to create a valid
  # Territory. As you add validations to Territory, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    Factory.attributes_for(:territory)
  end

  describe ".adjust_zipcode_ids" do
    before(:each) do
      @territory = mock_model(Territory, :zipcode_ids => [1,2,3])
      Territory.stub(:find).and_return(@territory)
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
      Territory.stub(:find).and_return(@territory)
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

  # describe "GET index" do
  #   it "assigns all territories as @territories" do
  #     territory = Territory.create! valid_attributes
  #     get :index
  #     assigns(:territories).should eq([territory])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested territory as @territory" do
  #     territory = Territory.create! valid_attributes
  #     get :show, :id => territory.id
  #     assigns(:territory).should eq(territory)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new territory as @territory" do
  #     get :new
  #     assigns(:territory).should be_a_new(Territory)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested territory as @territory" do
  #     territory = Territory.create! valid_attributes
  #     get :edit, :id => territory.id
  #     assigns(:territory).should eq(territory)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Territory" do
  #       expect {
  #         post :create, :territory => valid_attributes
  #       }.to change(Territory, :count).by(1)
  #     end

  #     it "assigns a newly created territory as @territory" do
  #       post :create, :territory => valid_attributes
  #       assigns(:territory).should be_a(Territory)
  #       assigns(:territory).should be_persisted
  #     end

  #     it "redirects to the created territory" do
  #       post :create, :territory => valid_attributes
  #       response.should redirect_to(Territory.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved territory as @territory" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Territory.any_instance.stub(:save).and_return(false)
  #       post :create, :territory => {}
  #       assigns(:territory).should be_a_new(Territory)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Territory.any_instance.stub(:save).and_return(false)
  #       post :create, :territory => {}
  #       response.should render_template("new")
  #     end
  #   end
  # end

  describe "PUT update" do
    before(:each) do
      @territory = Factory(:territory)
    end

    describe "with valid params" do
      context "territory_regions_attributes" do
        it "should adjust the associated regions according to the ids in params hash" do
          region1 = Factory(:region)
          region2 = Factory(:region)
          region3 = Factory(:region)
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

    describe "with invalid params" do
      #it "re-renders the 'edit' template" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Territory.any_instance.stub(:save).and_return(false)
        #put :update, :id => @territory.id, :territory => {}
        #response.should render_template("edit")
      #end
    end
  end

  # describe "DELETE destroy" do
  #   it "destroys the requested territory" do
  #     territory = Territory.create! valid_attributes
  #     expect {
  #       delete :destroy, :id => territory.id
  #     }.to change(Territory, :count).by(-1)
  #   end

  #   it "redirects to the territories list" do
  #     territory = Territory.create! valid_attributes
  #     delete :destroy, :id => territory.id
  #     response.should redirect_to(territories_url)
  #   end
  # end

end
