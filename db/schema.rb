# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_02_224616) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "affiliates", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "image_uid"
    t.string "website"
    t.string "twitch"
    t.string "twitter"
    t.string "facebook"
    t.string "instagram"
    t.string "youtube"
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "discord"
    t.string "mixer"
  end

  create_table "conduct_warnings", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.integer "pledge_id"
    t.integer "report_id"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reviewer_id"
    t.index ["reviewer_id"], name: "index_conduct_warnings_on_reviewer_id"
  end

  create_table "pledges", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "twitch_display_name"
    t.integer "twitch_id"
    t.datetime "signed_on"
    t.boolean "badge_revoked", default: false
    t.datetime "revoked_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitch_email"
    t.string "identifier"
    t.datetime "twitch_authed_on"
    t.integer "referrer_id"
    t.integer "referrals_count", default: 0
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.string "reporter_email"
    t.string "reporter_twitch_name"
    t.string "reported_twitch_name"
    t.string "image_uid"
    t.string "incident_stream"
    t.date "incident_occurred"
    t.text "incident_description"
    t.text "recommended_response"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reviewer_id"
    t.boolean "dismissed", default: false
    t.boolean "warned", default: false
    t.boolean "revoked", default: false
    t.index ["reviewer_id"], name: "index_reports_on_reviewer_id"
  end

  create_table "revocations", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.integer "pledge_id"
    t.integer "report_id"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reviewer_id"
    t.index ["reviewer_id"], name: "index_revocations_on_reviewer_id"
  end

  create_table "stories", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.string "image_uid"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "published", default: false
    t.datetime "published_on"
  end

  create_table "twitch_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_520_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.boolean "is_admin", default: false
    t.boolean "is_moderator", default: true
    t.string "image_uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "discord_username"
    t.string "player_id_type"
    t.string "player_id"
    t.string "gender"
    t.string "pronouns"
    t.string "social_profile"
    t.text "additional_notes"
    t.boolean "voice_requested", default: false
    t.string "status"
    t.datetime "requested_on"
    t.datetime "reviewed_on"
    t.integer "reviewer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier"
    t.text "denial_reason"
    t.boolean "photo_id_submitted", default: false
    t.boolean "doctors_note_submitted", default: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conduct_warnings", "users", column: "reviewer_id"
  add_foreign_key "reports", "users", column: "reviewer_id"
  add_foreign_key "revocations", "users", column: "reviewer_id"
end
