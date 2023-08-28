class Wine < ApplicationRecord
    validates :lowest_price, presence: true
    validates :highest_price, presence: true
    validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    
end
