# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
wine1 = Wine.create(name: 'Wine 1', lowest_price: 15.99, highest_price: 25.99, average_rating: 4.5)
Wine.create(name: 'Wine 2', lowest_price: 10.75, highest_price: 20.00, average_rating: 3.8)

Rating.create(wine: wine1, expert_id: 1, value: 7)
