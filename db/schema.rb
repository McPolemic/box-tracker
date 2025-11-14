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

ActiveRecord::Schema[8.1].define(version: 2025_11_14_002507) do
  create_table "auth_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_auth_tokens_on_token", unique: true
  end

  create_table "box_group_boxes", force: :cascade do |t|
    t.integer "box_group_id", null: false
    t.integer "box_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_group_id"], name: "index_box_group_boxes_on_box_group_id"
    t.index ["box_id"], name: "index_box_group_boxes_on_box_id"
  end

  create_table "box_group_images", force: :cascade do |t|
    t.integer "box_group_id", null: false
    t.datetime "created_at", null: false
    t.integer "image_id", null: false
    t.datetime "updated_at", null: false
    t.index ["box_group_id"], name: "index_box_group_images_on_box_group_id"
    t.index ["image_id"], name: "index_box_group_images_on_image_id"
  end

  create_table "box_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name"
    t.text "notes"
    t.datetime "updated_at", null: false
  end

  create_table "box_images", force: :cascade do |t|
    t.integer "box_id", null: false
    t.datetime "created_at", null: false
    t.integer "image_id", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id", "image_id"], name: "index_box_images_on_box_id_and_image_id", unique: true
    t.index ["box_id"], name: "index_box_images_on_box_id"
    t.index ["image_id"], name: "index_box_images_on_image_id"
  end

  create_table "boxes", force: :cascade do |t|
    t.text "contents"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name"
    t.text "notes"
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.binary "data"
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.binary "data"
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.binary "data"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "box_group_boxes", "box_groups"
  add_foreign_key "box_group_boxes", "boxes"
  add_foreign_key "box_group_images", "box_groups"
  add_foreign_key "box_group_images", "images"
  add_foreign_key "box_images", "boxes"
  add_foreign_key "box_images", "images"
end
