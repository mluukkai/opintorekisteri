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

ActiveRecord::Schema.define(:version => 20130615225826) do

  create_table "entries", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.decimal  "credits"
    t.string   "grade"
    t.string   "status"
    t.integer  "statuscode"
    t.string   "ordering"
    t.string   "creditDate"
    t.date     "date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "student_number"
    t.integer  "student_id"
    t.string   "department"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "start_year"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "student_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "paths", :force => true do |t|
    t.string   "started"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statistics", :force => true do |t|
    t.string   "started"
    t.string   "attrib"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "attrib2"
  end

  create_table "students", :force => true do |t|
    t.string   "student_number"
    t.string   "started"
    t.string   "attrib"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "attrib2"
    t.text     "month_credits"
  end

  add_index "students", ["student_number"], :name => "index_students_on_student_number"

end
