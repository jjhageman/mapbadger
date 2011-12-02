require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe TerritoriesController do

  # This should return the minimal set of attributes required to create a valid
  # Territory. As you add validations to Territory, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all territories as @territories" do
      territory = Territory.create! valid_attributes
      get :index
      assigns(:territories).should eq([territory])
    end
  end

  describe "GET show" do
    it "assigns the requested territory as @territory" do
      territory = Territory.create! valid_attributes
      get :show, :id => territory.id
      assigns(:territory).should eq(territory)
    end
  end

  describe "GET new" do
    it "assigns a new territory as @territory" do
      get :new
      assigns(:territory).should be_a_new(Territory)
    end
  end

  describe "GET edit" do
    it "assigns the requested territory as @territory" do
      territory = Territory.create! valid_attributes
      get :edit, :id => territory.id
      assigns(:territory).should eq(territory)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Territory" do
        expect {
          post :create, :territory => valid_attributes
        }.to change(Territory, :count).by(1)
      end

      it "assigns a newly created territory as @territory" do
        post :create, :territory => valid_attributes
        assigns(:territory).should be_a(Territory)
        assigns(:territory).should be_persisted
      end

      it "redirects to the created territory" do
        post :create, :territory => valid_attributes
        response.should redirect_to(Territory.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved territory as @territory" do
        # Trigger the behavior that occurs when invalid params are submitted
        Territory.any_instance.stub(:save).and_return(false)
        post :create, :territory => {}
        assigns(:territory).should be_a_new(Territory)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Territory.any_instance.stub(:save).and_return(false)
        post :create, :territory => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested territory" do
        territory = Territory.create! valid_attributes
        # Assuming there are no other territories in the database, this
        # specifies that the Territory created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Territory.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => territory.id, :territory => {'these' => 'params'}
      end

      it "assigns the requested territory as @territory" do
        territory = Territory.create! valid_attributes
        put :update, :id => territory.id, :territory => valid_attributes
        assigns(:territory).should eq(territory)
      end

      it "redirects to the territory" do
        territory = Territory.create! valid_attributes
        put :update, :id => territory.id, :territory => valid_attributes
        response.should redirect_to(territory)
      end
    end

    describe "with invalid params" do
      it "assigns the territory as @territory" do
        territory = Territory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Territory.any_instance.stub(:save).and_return(false)
        put :update, :id => territory.id, :territory => {}
        assigns(:territory).should eq(territory)
      end

      it "re-renders the 'edit' template" do
        territory = Territory.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Territory.any_instance.stub(:save).and_return(false)
        put :update, :id => territory.id, :territory => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested territory" do
      territory = Territory.create! valid_attributes
      expect {
        delete :destroy, :id => territory.id
      }.to change(Territory, :count).by(-1)
    end

    it "redirects to the territories list" do
      territory = Territory.create! valid_attributes
      delete :destroy, :id => territory.id
      response.should redirect_to(territories_url)
    end
  end

end