class Wine < ApplicationRecord
    validates :lowest_price, presence: true
    validates :highest_price, presence: true
    validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    
    scope :price_max, -> (max) { where("lowest_price <= ?", max) if max.present? }
    scope :price_min, -> (min) { where("highest_price >= ?", min) if min.present? }
    scope :order_by_rating, -> { order(rating: :desc) }
end
