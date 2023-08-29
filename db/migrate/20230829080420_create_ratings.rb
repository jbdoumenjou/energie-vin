# frozen_string_literal: true

# Creates the "ratings" table.
class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.decimal :value
      t.integer :expert_id
      t.belongs_to :wine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
