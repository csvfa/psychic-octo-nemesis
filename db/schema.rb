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

ActiveRecord::Schema.define(:version => 20140923175358) do

  create_table "availability_slots", :force => true do |t|
    t.time     "available_from"
    t.time     "available_to"
    t.integer  "studio_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "bookings", :force => true do |t|
    t.datetime "timeslot"
    t.integer  "theme_id"
    t.text     "special_requirements"
    t.integer  "status"
    t.datetime "last_status_date"
    t.text     "notes"
    t.integer  "coach_id"
    t.datetime "when_coach_booked"
    t.datetime "when_job_sheet_sent"
    t.string   "venue_booked_with"
    t.boolean  "advance_venue_payment_required"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "customer_id"
    t.integer  "studio_id"
    t.integer  "sales_person_id"
    t.integer  "city_id"
    t.string   "offer"
    t.decimal  "rate_per_guest",                 :precision => 8, :scale => 2
    t.date     "offer_expires_on"
    t.text     "enquiry_method"
    t.integer  "pricing_structure_id"
  end

  add_index "bookings", ["coach_id"], :name => "index_bookings_on_coach_id"
  add_index "bookings", ["theme_id"], :name => "index_bookings_on_theme_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "region"
    t.integer  "latitude"
  end

  create_table "cities_coaches", :id => false, :force => true do |t|
    t.integer "city_id"
    t.integer "coach_id"
  end

  create_table "coaches", :force => true do |t|
    t.string   "first_name"
    t.string   "phone"
    t.string   "email"
    t.integer  "day_rate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "surname"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "telephone_number"
    t.string   "email"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "code"
    t.text     "notes"
    t.integer  "booking_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "occurred_at"
    t.string   "action"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "type"
  end

  add_index "events", ["booking_id"], :name => "index_statuses_on_booking_id"

  create_table "events_companies", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "website"
    t.string   "email"
    t.string   "phone"
    t.text     "service_agreement"
    t.text     "payment_terms"
    t.text     "notes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "guests", :force => true do |t|
    t.integer  "number"
    t.datetime "changed_at"
    t.integer  "booking_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "guests", ["booking_id"], :name => "index_guests_on_booking_id"

  create_table "invoices", :force => true do |t|
    t.string   "ref"
    t.date     "invoice_date"
    t.date     "deposit_due_date"
    t.date     "balance_due_date"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "booking_id"
    t.integer  "version_number"
    t.decimal  "deposit_amount",   :precision => 8, :scale => 2
  end

  add_index "invoices", ["booking_id"], :name => "index_invoices_on_booking_id"

  create_table "managers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "opening_times", :force => true do |t|
    t.integer  "day_of_week"
    t.time     "opening_time"
    t.time     "closing_time"
    t.integer  "venue_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "opening_times", ["venue_id"], :name => "index_opening_times_on_venue_id"

  create_table "pricing_structures", :force => true do |t|
    t.text     "name"
    t.decimal  "rate_per_person",  :precision => 8, :scale => 2
    t.integer  "min_people"
    t.decimal  "min_cost",         :precision => 8, :scale => 2
    t.date     "expiry_date"
    t.text     "terms"
    t.text     "notes"
    t.text     "initial_response"
    t.text     "booking_response"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "received_line_items", :force => true do |t|
    t.date     "received_on"
    t.decimal  "amount",         :precision => 8, :scale => 2
    t.string   "payment_method"
    t.integer  "invoice_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "sales_people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "events_company_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "sales_people", ["events_company_id"], :name => "index_sales_people_on_events_company_id"

  create_table "service_provided_line_items", :force => true do |t|
    t.date     "entry_date"
    t.string   "description"
    t.integer  "no_people"
    t.decimal  "rate_per_person", :precision => 8, :scale => 2
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.integer  "invoice_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.decimal  "price",          :precision => 8, :scale => 2
    t.time     "available_from"
    t.time     "available_to"
    t.text     "notes"
    t.integer  "venue_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "studios", ["venue_id"], :name => "index_studios_on_venue_id"

  create_table "suggested_slots", :force => true do |t|
    t.time     "time"
    t.integer  "studio_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "suggested_slots", ["studio_id"], :name => "index_suggested_slots_on_studio_id"

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.text     "gifts"
    t.text     "kit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.text     "payment_procedure"
    t.text     "notes"
    t.integer  "city_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "address"
  end

  add_index "venues", ["city_id"], :name => "index_venues_on_city_id"

end
