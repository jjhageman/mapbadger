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

ActiveRecord::Schema.define(:version => 20120225183629) do

  create_table "geometries", :force => true do |t|
    t.text    "polyline"
    t.integer "region_id"
    t.integer "zipcode_id"
    t.spatial "area",       :limit => {:srid=>3785, :type=>"polygon"}
  end

  add_index "geometries", ["region_id"], :name => "index_geometries_on_region_id"
  add_index "geometries", ["zipcode_id"], :name => "index_geometries_on_zipcode_id"

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
    t.string "name"
    t.string "fipscode"
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

  create_table "territory_zipcodes", :force => true do |t|
    t.integer  "zipcode_id"
    t.integer  "territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "territory_zipcodes", ["territory_id"], :name => "index_territory_zipcodes_on_territory_id"
  add_index "territory_zipcodes", ["zipcode_id"], :name => "index_territory_zipcodes_on_zipcode_id"

  create_table "zipcodes", :force => true do |t|
    t.string  "name"
    t.integer "region_id"
  end

end
