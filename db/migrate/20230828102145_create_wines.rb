# frozen_string_literal: true

# Creates the "wines" table.
class CreateWines < ActiveRecord::Migration[7.0]
  def change
    create_table :wines do |t|
      t.string :name
      t.decimal :lowest_price
      t.decimal :highest_price
      t.decimal :average_rating

      t.timestamps
    end
  end
end
