require "spec_helper"

describe TerritoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/territories").should route_to("territories#index")
    end

    it "routes to #new" do
      get("/territories/new").should route_to("territories#new")
    end

    it "routes to #show" do
      get("/territories/1").should route_to("territories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/territories/1/edit").should route_to("territories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/territories").should route_to("territories#create")
    end

    it "routes to #update" do
      put("/territories/1").should route_to("territories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/territories/1").should route_to("territories#destroy", :id => "1")
    end

  end
end
