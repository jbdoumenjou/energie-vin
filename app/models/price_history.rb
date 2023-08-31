# frozen_string_literal: true

# Represents the wine price history.
class PriceHistory < ApplicationRecord
  # Relation
  belongs_to :wine

  # Validation
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :seller_site, presence: true, allow_blank: false
end
