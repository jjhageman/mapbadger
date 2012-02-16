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

ActiveRecord::Schema.define(:version => 20120215195808) do

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
    t.string  "zcta"
    t.spatial "region",   :limit => {:srid=>3785, :type=>"polygon"}
    t.text    "polyline"
  end

  add_index "zcta", ["region"], :name => "index_zcta_on_region", :spatial => true

end
