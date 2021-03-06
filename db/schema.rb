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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131020110020) do

  create_table "answers", force: true do |t|
    t.string   "value",            null: false
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "normalized_value"
  end

  add_index "answers", ["question_id", "normalized_value"], name: "index_answers_on_question_id_and_normalized_value", unique: true
  add_index "answers", ["question_id", "value"], name: "index_answers_on_question_id_and_value", unique: true
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.text     "auth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true
  add_index "authentications", ["user_id", "provider"], name: "index_authentications_on_user_id_and_provider", unique: true

  create_table "daily_statistics", force: true do |t|
    t.integer "user_id"
    t.string  "locale"
    t.date    "stats_date"
    t.float   "fastest_answer"
    t.integer "answers_in_a_row"
    t.integer "correct_answers"
  end

  add_index "daily_statistics", ["locale", "stats_date", "user_id"], name: "index_daily_statistics_on_locale_and_stats_date_and_user_id", unique: true
  add_index "daily_statistics", ["user_id"], name: "index_daily_statistics_on_user_id"

  create_table "question_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_categories", ["name"], name: "index_question_categories_on_name", unique: true

  create_table "questions", force: true do |t|
    t.text     "text",                 null: false
    t.integer  "question_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
  end

  add_index "questions", ["locale"], name: "index_questions_on_locale"
  add_index "questions", ["question_category_id"], name: "index_questions_on_question_category_id"
  add_index "questions", ["text"], name: "index_questions_on_text", unique: true

  create_table "room_questions", force: true do |t|
    t.integer  "question_id", null: false
    t.integer  "room_id",     null: false
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "room_questions", ["question_id", "room_id"], name: "index_room_questions_on_question_id_and_room_id", unique: true
  add_index "room_questions", ["question_id"], name: "index_room_questions_on_question_id"
  add_index "room_questions", ["room_id"], name: "index_room_questions_on_room_id"
  add_index "room_questions", ["winner_id"], name: "index_room_questions_on_winner_id"

  create_table "rooms", force: true do |t|
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count"
    t.string   "locale"
  end

  add_index "rooms", ["name"], name: "index_rooms_on_name", unique: true
  add_index "rooms", ["users_count"], name: "index_rooms_on_users_count"

  create_table "suggested_answers", force: true do |t|
    t.string   "value"
    t.integer  "user_id"
    t.integer  "room_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_valid"
  end

  add_index "suggested_answers", ["room_question_id"], name: "index_suggested_answers_on_room_question_id"
  add_index "suggested_answers", ["user_id"], name: "index_suggested_answers_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
    t.string   "avatar"
    t.boolean  "guest"
    t.float    "rating"
  end

  add_index "users", ["room_id"], name: "index_users_on_room_id"

end
