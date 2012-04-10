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

ActiveRecord::Schema.define(:version => 20120409010234) do

  create_table "companies", :force => true do |t|
    t.string   "company_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.integer  "company_size"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["confirmation_token"], :name => "index_companies_on_confirmation_token", :unique => true
  add_index "companies", ["email"], :name => "index_companies_on_email", :unique => true
  add_index "companies", ["reset_password_token"], :name => "index_companies_on_reset_password_token", :unique => true

  create_table "csvs", :force => true do |t|
    t.string   "file"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "csvs", ["company_id"], :name => "index_csvs_on_company_id"

  create_table "geometries", :force => true do |t|
    t.text    "polyline"
    t.integer "region_id"
    t.integer "zipcode_id"
    t.spatial "area",       :limit => {:srid=>3785, :type=>"polygon"}
  end

  add_index "geometries", ["area"], :name => "index_geometries_on_area", :spatial => true
  add_index "geometries", ["region_id"], :name => "index_geometries_on_region_id"
  add_index "geometries", ["zipcode_id"], :name => "index_geometries_on_zipcode_id"

  create_table "nasdaq_companies", :force => true do |t|
    t.string  "name"
    t.string  "address1"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.string  "zipcode"
    t.float   "lat"
    t.float   "lng"
    t.spatial "location", :limit => {:srid=>3785, :type=>"point"}
  end

  add_index "nasdaq_companies", ["location"], :name => "index_nasdaq_companies_on_location"

  create_table "notifications", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opportunities", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "company_id"
    t.spatial  "location",   :limit => {:srid=>3785, :type=>"point"}
  end

  add_index "opportunities", ["company_id"], :name => "index_opportunities_on_company_id"
  add_index "opportunities", ["location"], :name => "index_opportunities_on_location", :spatial => true

  create_table "regions", :force => true do |t|
    t.string "name"
    t.string "fipscode"
  end

  create_table "representatives", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  add_index "representatives", ["company_id"], :name => "index_representatives_on_company_id"

  create_table "territories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "representative_id"
    t.integer  "company_id"
  end

  add_index "territories", ["company_id"], :name => "index_territories_on_company_id"
  add_index "territories", ["representative_id"], :name => "index_territories_on_representative_id"

  create_table "territory_regions", :force => true do |t|
    t.integer  "region_id"
    t.integer  "territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "zipcodes", ["region_id"], :name => "index_zcta_on_region_id"

end
