# frozen_string_literal: true

# Creates the "histories" table.
class CreatePriceHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :price_histories do |t|
      t.belongs_to :wine, null: false, foreign_key: true
      t.string :seller_site
      t.decimal :price

      t.timestamps
    end
  end
end
