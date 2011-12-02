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

ActiveRecord::Schema.define(:version => 20111130083655) do

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "fipscode"
    t.text     "coords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "territories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "territory_regions", :force => true do |t|
    t.integer  "territory_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "territory_regions", ["region_id"], :name => "index_territory_regions_on_region_id"
  add_index "territory_regions", ["territory_id"], :name => "index_territory_regions_on_territory_id"

end
