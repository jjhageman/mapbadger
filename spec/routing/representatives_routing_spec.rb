require "spec_helper"

describe RepresentativesController do
  describe "routing" do

    it "routes to #index" do
      get("/representatives").should route_to("representatives#index")
    end

    it "routes to #new" do
      get("/representatives/new").should route_to("representatives#new")
    end

    it "routes to #show" do
      get("/representatives/1").should route_to("representatives#show", :id => "1")
    end

    it "routes to #edit" do
      get("/representatives/1/edit").should route_to("representatives#edit", :id => "1")
    end

    it "routes to #create" do
      post("/representatives").should route_to("representatives#create")
    end

    it "routes to #update" do
      put("/representatives/1").should route_to("representatives#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/representatives/1").should route_to("representatives#destroy", :id => "1")
    end

  end
end
