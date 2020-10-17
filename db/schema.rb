# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_17_143346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "architectures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "builders", force: :cascade do |t|
    t.integer "architecture_id"
    t.string "hostname"
    t.string "owner"
    t.string "location"
    t.datetime "lastheard"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "osbuild"
    t.integer "threads"
    t.string "client_version"
  end

  create_table "builds", force: :cascade do |t|
    t.integer "architecture_id"
    t.integer "builder_id"
    t.integer "recipe_id"
    t.datetime "issued"
    t.datetime "completed"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.integer "asset_id"
    t.integer "result"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "repo_id"
    t.integer "architecture_id"
    t.integer "latestrev"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.integer "revision"
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.text "lint"
    t.integer "lintret"
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "lastrefresh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
