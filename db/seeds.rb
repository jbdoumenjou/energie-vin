# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

wine1 = Wine.create(name: 'Wine 1', lowest_price: 15.99, highest_price: 25.99, average_rating: 8)
Rating.create(wine: wine1, expert_id: 1, value: 7)
Rating.create(wine: wine1, expert_id: 2, value: 9)
Price.create(wine: wine1, seller_site: 'www.example.wine.com', price: 15.99)
Price.create(wine: wine1, seller_site: 'www.example.wine2.com', price: 25.99)
PriceHistory.create(wine: wine1, price: 15.99, seller_site: 'www.example.wine.com')
PriceHistory.create(wine: wine1, price: 25.99, seller_site: 'www.example.wine2.com')

wine2 = Wine.create(name: 'Wine 2', lowest_price: 10.75, highest_price: 20.00, average_rating: 3.8)
Rating.create(wine: wine2, expert_id: 1, value: 2)
Rating.create(wine: wine2, expert_id: 2, value: 5.6)
Price.create(wine: wine2, seller_site: 'www.example.wine.com', price: 20.00)
Price.create(wine: wine2, seller_site: 'www.example.wine2.com', price: 10.75)
PriceHistory.create(wine: wine2, price: 20.00, seller_site: 'www.example.wine.com')
PriceHistory.create(wine: wine2, price: 10.75, seller_site: 'www.example.wine2.com')

wine3 = Wine.create(name: 'Wine 3', lowest_price: 100.25, highest_price: 200.00, average_rating: 9)
Rating.create(wine: wine3, expert_id: 1, value: 10)
Rating.create(wine: wine3, expert_id: 2, value: 8)
Price.create(wine: wine3, seller_site: 'www.example.wine.com', price: 100.25)
Price.create(wine: wine3, seller_site: 'www.example.wine2.com', price: 200.00)
PriceHistory.create(wine: wine3, price: 100.25, seller_site: 'www.example.wine.com')
PriceHistory.create(wine: wine3, price: 200.00, seller_site: 'www.example.wine2.com')
