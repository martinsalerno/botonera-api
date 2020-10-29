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

ActiveRecord::Schema.define(version: 20_201_026_005_956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'keyboards', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'name', null: false
    t.jsonb 'keys', default: {}, null: false
    t.index %w[user_id name], name: 'index_keyboards_on_user_id_and_name', unique: true
  end

  create_table 'sounds', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'name', null: false
    t.string 'path', null: false
    t.index ['path'], name: 'index_sounds_on_path', unique: true
    t.index %w[user_id name], name: 'index_sounds_on_user_id_and_name', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.integer 'oauth_provider'
    t.string 'acccess_token'
    t.string 'refresh_token'
    t.datetime 'expiry_date'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
