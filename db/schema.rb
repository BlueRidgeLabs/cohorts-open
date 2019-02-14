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

ActiveRecord::Schema.define(version: 20181005182003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "person_id"
    t.integer  "submission_id"
    t.text     "value"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "subfields",     default: [],              array: true
  end

  add_index "answers", ["person_id"], name: "index_answers_on_person_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["submission_id"], name: "index_answers_on_submission_id", using: :btree

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checklists", force: :cascade do |t|
    t.string   "name"
    t.string   "items",      default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",                          null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "saved_search_ids", default: [],              array: true
    t.integer  "checklist_ids",    default: [],              array: true
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "contact_type"
    t.text     "notes"
    t.datetime "contact_time"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.integer  "created_by"
  end

  create_table "email_messages", force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.string   "body"
    t.integer  "person_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "delivery_method"
    t.string   "thread_id"
    t.datetime "time_sent"
    t.string   "gmail_id"
  end

  create_table "engagements", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "topic",                         null: false
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "saved_search_ids", default: [],              array: true
    t.integer  "checklist_ids",    default: [],              array: true
  end

  add_index "engagements", ["client_id"], name: "index_engagements_on_client_id", using: :btree

  create_table "extrapolated_answers", force: :cascade do |t|
    t.integer "answer_id"
  end

  add_index "extrapolated_answers", ["answer_id"], name: "index_extrapolated_answers_on_answer_id", using: :btree

  create_table "extrapolated_comments", force: :cascade do |t|
    t.integer "comment_id"
  end

  add_index "extrapolated_comments", ["comment_id"], name: "index_extrapolated_comments_on_comment_id", using: :btree

  create_table "forms", force: :cascade do |t|
    t.string   "hash_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.boolean  "hidden",         default: false
    t.datetime "created_on"
    t.datetime "last_update"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "twilio_keyword"
    t.hstore   "mapping"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gift_cards", force: :cascade do |t|
    t.string   "gift_card_number"
    t.string   "expiration_date"
    t.integer  "person_id"
    t.string   "notes"
    t.integer  "created_by"
    t.integer  "reason"
    t.integer  "amount_cents",     default: 0,     null: false
    t.string   "amount_currency",  default: "USD", null: false
    t.integer  "giftable_id"
    t.string   "giftable_type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "batch_id"
    t.integer  "proxy_id"
  end

  add_index "gift_cards", ["giftable_type", "giftable_id"], name: "index_gift_cards_on_giftable_type_and_giftable_id", using: :btree
  add_index "gift_cards", ["reason"], name: "gift_reason_index", using: :btree

  create_table "landing_pages", force: :cascade do |t|
    t.string   "lede"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "tag_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "body"
    t.integer  "form_id"
    t.string   "format"
  end

  add_index "landing_pages", ["form_id"], name: "index_landing_pages_on_form_id", using: :btree
  add_index "landing_pages", ["tag_id"], name: "index_landing_pages_on_tag_id", using: :btree

  create_table "mailchimp_exports", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailchimp_updates", force: :cascade do |t|
    t.text     "raw_content"
    t.string   "email"
    t.string   "update_type"
    t.string   "reason"
    t.datetime "fired_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "geography_id"
    t.integer  "primary_device_id"
    t.string   "primary_device_description"
    t.integer  "secondary_device_id"
    t.string   "secondary_device_description"
    t.integer  "primary_connection_id"
    t.string   "primary_connection_description"
    t.string   "phone_number"
    t.string   "participation_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "signup_ip"
    t.datetime "signup_at"
    t.integer  "secondary_connection_id"
    t.string   "secondary_connection_description"
    t.string   "verified"
    t.string   "preferred_contact_method"
    t.string   "token"
    t.boolean  "active",                           default: true
    t.datetime "deactivated_at"
    t.string   "deactivated_method"
    t.integer  "signup_form_id"
    t.integer  "tag_count_cache"
    t.datetime "last_contacted"
  end

  create_table "person_traits", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "trait_id",  null: false
    t.string  "value",     null: false
  end

  add_index "person_traits", ["person_id"], name: "index_person_traits_on_person_id", using: :btree
  add_index "person_traits", ["trait_id"], name: "index_person_traits_on_trait_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.string   "short_text"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "form_id"
    t.string   "datatype"
    t.string   "field_id"
    t.datetime "version_date"
    t.string   "choices",       default: [],              array: true
    t.string   "subfields",     default: [],              array: true
    t.integer  "answers_count", default: 0
  end

  create_table "research_sessions", force: :cascade do |t|
    t.integer  "engagement_id"
    t.datetime "datetime",      null: false
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "research_sessions", ["engagement_id"], name: "index_research_sessions_on_engagement_id", using: :btree
  add_index "research_sessions", ["engagement_id"], name: "research_sessions_engagement_id_idx", using: :btree

  create_table "rules", force: :cascade do |t|
    t.string   "subject_class",              null: false
    t.hstore   "filters",       default: {}
    t.string   "action_type",                null: false
    t.string   "action_value",               null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "saved_searches", force: :cascade do |t|
    t.string   "label"
    t.string   "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_checklists", force: :cascade do |t|
    t.integer  "research_session_id"
    t.integer  "checklist_id"
    t.hstore   "state"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "session_checklists", ["checklist_id"], name: "index_session_checklists_on_checklist_id", using: :btree
  add_index "session_checklists", ["research_session_id"], name: "index_session_checklists_on_research_session_id", using: :btree

  create_table "session_invites", id: false, force: :cascade do |t|
    t.integer  "research_session_id", null: false
    t.integer  "person_id",           null: false
    t.boolean  "attended"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "session_invites", ["person_id"], name: "index_session_invites_on_person_id", using: :btree
  add_index "session_invites", ["research_session_id"], name: "index_session_invites_on_research_session_id", using: :btree

  create_table "sms_forms", force: :cascade do |t|
    t.integer  "form_id"
    t.string   "phone_number"
    t.hstore   "values"
    t.integer  "field_counter"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "sms_forms", ["form_id"], name: "index_sms_forms_on_form_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "pixel_code"
    t.string   "link_description"
  end

  create_table "submissions", force: :cascade do |t|
    t.text     "raw_content"
    t.integer  "person_id"
    t.string   "ip_addr"
    t.string   "entry_id"
    t.text     "form_structure"
    t.text     "field_structure"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_type",       default: 0
    t.integer  "form_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taggings_count", default: 0, null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string   "name",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "person_traits_count", default: 0
  end

  create_table "twilio_messages", force: :cascade do |t|
    t.string   "message_sid"
    t.datetime "date_sent"
    t.string   "account_sid"
    t.string   "from"
    t.string   "to"
    t.string   "body"
    t.string   "status"
    t.string   "error_code"
    t.string   "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "previous_message_id"
    t.integer  "person_id"
    t.integer  "sms_form_id"
    t.integer  "user_id"
  end

  add_index "twilio_messages", ["person_id"], name: "index_twilio_messages_on_person_id", using: :btree
  add_index "twilio_messages", ["previous_message_id"], name: "index_twilio_messages_on_previous_message_id", using: :btree
  add_index "twilio_messages", ["sms_form_id"], name: "index_twilio_messages_on_sms_form_id", using: :btree
  add_index "twilio_messages", ["user_id"], name: "index_twilio_messages_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",    null: false
    t.string   "encrypted_password",            default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "invitation_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",                      default: false, null: false
    t.string   "name"
    t.string   "token"
    t.string   "phone_number"
    t.integer  "second_factor_attempts_count",  default: 0
    t.string   "encrypted_otp_secret_key"
    t.string   "encrypted_otp_secret_key_iv"
    t.string   "encrypted_otp_secret_key_salt"
    t.string   "oauth_provider"
    t.string   "oauth_uid"
    t.string   "oauth_token"
    t.string   "oauth_refresh_token"
    t.string   "image_url"
    t.integer  "unread_messages",               default: 0
    t.string   "direct_otp"
    t.datetime "direct_otp_sent_at"
    t.datetime "totp_timestamp"
  end

  add_index "users", ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true, using: :btree

  create_table "v2_event_invitations", force: :cascade do |t|
    t.integer  "v2_event_id"
    t.string   "people_ids"
    t.string   "description"
    t.string   "slot_length"
    t.string   "date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "buffer",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "answers", "people"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "engagements", "clients"
  add_foreign_key "extrapolated_answers", "answers"
  add_foreign_key "extrapolated_comments", "comments"
  add_foreign_key "landing_pages", "forms"
  add_foreign_key "landing_pages", "tags"
  add_foreign_key "questions", "forms"
  add_foreign_key "session_checklists", "checklists"
  add_foreign_key "session_checklists", "research_sessions"
  add_foreign_key "sms_forms", "forms"
  add_foreign_key "submissions", "forms"
  add_foreign_key "twilio_messages", "people"
  add_foreign_key "twilio_messages", "sms_forms"
  add_foreign_key "twilio_messages", "users"
end
