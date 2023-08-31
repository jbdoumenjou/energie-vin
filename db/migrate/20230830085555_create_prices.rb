# frozen_string_literal: true

# Creates the "prices" table.
class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.belongs_to :wine, null: false, foreign_key: true
      t.string :seller_site
      t.decimal :price
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
