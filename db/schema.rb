# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120209042029) do

  create_table "mapbadger", :primary_key => "gid", :force => true do |t|
    t.string  "statefp10",  :limit => 2
    t.string  "zcta5ce10",  :limit => 5
    t.string  "geoid10",    :limit => 7
    t.string  "classfp10",  :limit => 2
    t.string  "mtfcc10",    :limit => 5
    t.string  "funcstat10", :limit => 1
    t.float   "aland10"
    t.float   "awater10"
    t.string  "intptlat10", :limit => 11
    t.string  "intptlon10", :limit => 12
    t.string  "partflg10",  :limit => 1
    t.spatial "the_geom",   :limit => {:srid=>4326, :type=>"multi_polygon"}
  end

  create_table "opportunities", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.float    "lat"
    t.float    "lng"
    t.spatial  "location",   :limit => {:srid=>4326, :type=>"point", :geographic=>true}
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "fipscode"
    t.text     "coords"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "representatives", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "territories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "representative_id"
  end

  add_index "territories", ["representative_id"], :name => "index_territories_on_representative_id"

  create_table "territory_regions", :force => true do |t|
    t.integer  "region_id"
    t.integer  "territory_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "territory_regions", ["region_id"], :name => "index_territory_regions_on_region_id"
  add_index "territory_regions", ["territory_id"], :name => "index_territory_regions_on_territory_id"

  create_table "zcta", :force => true do |t|
    t.integer "zcta"
    t.spatial "region", :limit => {:srid=>3785, :type=>"polygon"}
  end

  add_index "zcta", ["region"], :name => "index_zcta_on_region", :spatial => true

  create_table "zipcodes", :force => true do |t|
    t.string  "zipcode"
    t.string  "state_fp"
    t.spatial "polygon",  :limit => {:srid=>-1, :type=>"geometry"}
  end

end
