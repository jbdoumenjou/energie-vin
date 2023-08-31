# frozen_string_literal: true

# Represents a wine in the application.
class Wine < ApplicationRecord
  # Relations
  has_many :ratings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :price_histories, dependent: :destroy

  # Validations
  validates :lowest_price, presence: true
  validates :highest_price, presence: true
  validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  # Scopes
  scope :price_max, ->(max) { where('lowest_price <= ?', max) if max.present? }
  scope :price_min, ->(min) { where('highest_price >= ?', min) if min.present? }
  scope :order_by_rating, -> { order(average_rating: :desc) }

  # Calculates and updates the average rating for a wine based on its related ratings.
  #
  # @return [void]
  def update_average_rating
    self.average_rating = if ratings.count.zero?
                            0
                          else
                            ratings.average(:value)
                          end
    save
  end

  # Updates a specific price for a wine and manages price history.
  #
  # @param [String] seller_site The seller site associated with the price.
  # @param [Decimal] price_value The value of the price to update.
  # @return [void]
  def update_price(seller_site, price_value)
    # Update price range and save if necessary.
    update_price_interval(price_value)
    save if price_interval_updated?

    # Update price history.
    PriceHistory.create(wine_id: id, seller_site: seller_site, price: price_value)
  end

  private

  # Update the lowest and highest price if needed.
  #
  # @param [Decimal] price_value The value of the price to consider for updates.
  # @return [void]
  def update_price_interval(price_value)
    self.lowest_price = price_value if lowest_price.nil? || price_value < lowest_price
    self.highest_price = price_value if highest_price.nil? || price_value > highest_price
  end

  # Check if the price interval was updated.
  #
  # @return [Boolean] True if the price interval was updated, otherwise false.
  def price_interval_updated?
    changes.include?(:lowest_price) || changes.include?(:highest_price)
  end
end
