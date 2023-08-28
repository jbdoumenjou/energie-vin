# frozen_string_literal: true

# Represents a wine in the application.
class Wine < ApplicationRecord
  # Validations
  validates :lowest_price, presence: true
  validates :highest_price, presence: true
  validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  # Scopes
  scope :price_max, ->(max) { where('lowest_price <= ?', max) if max.present? }
  scope :price_min, ->(min) { where('highest_price >= ?', min) if min.present? }
  scope :order_by_rating, -> { order(average_rating: :desc) }
end
