# frozen_string_literal: true

# Represents a rating in the application.
class Rating < ApplicationRecord
  # Relation
  belongs_to :wine

  # Validation
  validates :expert_id, presence: true
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
