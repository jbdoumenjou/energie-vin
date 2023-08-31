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

  # Calculates the average rating from all related ratings
  def update_average_rating
    self.average_rating = if ratings.count.zero?
                            0
                          else
                            ratings.average(:value)
                          end
    save
  end

  def update_price(seller_site, price_value)
    # Update price range and save if necessary.
    update_price_interval(price_value)
    save if price_interval_updated?

    # Update price history.
    PriceHistory.create(wine_id: id, seller_site: seller_site, price: price_value)
  end

  private

  # Update the lowest and highest price if needed.
  def update_price_interval(price_value)
    self.lowest_price = price_value if lowest_price.nil? || price_value < lowest_price
    self.highest_price = price_value if highest_price.nil? || price_value > highest_price
  end

  # Check if the price interval was updated.
  def price_interval_updated?
    changes.include?(:lowest_price) || changes.include?(:highest_price)
  end
end
