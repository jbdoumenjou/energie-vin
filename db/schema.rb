# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_830_141_057) do
  create_table 'price_histories', force: :cascade do |t|
    t.integer 'wine_id', null: false
    t.string 'seller_site'
    t.decimal 'price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['wine_id'], name: 'index_price_histories_on_wine_id'
  end

  create_table 'prices', force: :cascade do |t|
    t.integer 'wine_id', null: false
    t.string 'seller_site'
    t.decimal 'price'
    t.datetime 'fetched_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['wine_id'], name: 'index_prices_on_wine_id'
  end

  create_table 'ratings', force: :cascade do |t|
    t.decimal 'value'
    t.integer 'expert_id'
    t.integer 'wine_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['wine_id'], name: 'index_ratings_on_wine_id'
  end

  create_table 'wines', force: :cascade do |t|
    t.string 'name'
    t.decimal 'lowest_price'
    t.decimal 'highest_price'
    t.decimal 'average_rating'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'price_histories', 'wines'
  add_foreign_key 'prices', 'wines'
  add_foreign_key 'ratings', 'wines'
end
