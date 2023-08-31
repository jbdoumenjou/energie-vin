# Notes

This is a work in progress document showing the thinking behind the project.

## Kind of project

It's a webapp exposing API of wines searchable by prices and ratings.
A graphic user interface would be a plus.

## Competition

* https://www.wine-searcher.com/
* https://www.vivino.com


## User Stories

* As an administrator, I can load data from an external source.
* As a wine expert, I can manage my ratings on wines.
* As a user:
  * I can search for wine based on a price interval and the average rating.
  * I can save my search and be notified when a wine matches my criteria.
  * I can check the price history of a wine to understand the trend.
* As a developer:
  * I can start the webapp to expose the API.
  * I can easily understand the project and implement the new features.
  * I can easily test and deploy my code

## Model

To bootstrap the project, let's keep the model as simple as possible.  
We need a source of data with wine properties and prices associated to a selling_site.

The minimal data needed in the wine data source.

* wine properties (to define)
  * name (minimal data to distinguish wines)
* Price
    * selling_site
    * price (€)
    * lastUpdate -> check if we need to keep a trace of the update
* Expert ratings
  * rating1
  * rating2
* Average rating (the average of all expert ratings)

The wine must be searchable by ratings and price
A search could be saved to revieved alert when a wine match the criteria.
Search Model:
* price interval (€)
* average rating

We need to load a file or any source file to have the wine database.
The only public call will be the wine search with two criteria.
An administration API could be added later to manage known wines.
A specific access may be created for the experts ratings.

As we don't know the initial model the chances are that we have a list of data by selling_site,
and may or may not have the date associated to those data :

```json
[
  {
	name: "my wine 1",
	selling_site: "selling_site 1",
	price: 20.5,
  },
  {
	name: "my wine 1",
	selling_site: "selling_site 2",
	price: 21.5,
  },
  {
	name: "my wine 2",
	selling_site: "selling_site 1",
	price: 18.5,
  },
 
]
```

This will need to create a specific result that take all the wines with the same name and merge prices & selling sites in a someting like a view
Or a more complex one.

```json
[
  {
	name: "my wine 1",
	lower_price: 20.5,
	highest_price: 21.5,
	prices: [
  	{
    	selling_site: "selling_site 1",
    	price: 20.5,
  	},
  	{
    	selling_site: "selling_site 2",
    	price: 21.5,
  	},
	],
	average_rating: sum(ratings)/len(ratings)
	ratings: [
  	4.5,
  	5
	]
  },
]
```
The lowest and highest prices are entered when data is retrieved from the external service.
This makes it possible to quickly search for a price range and reduce the calculation of these values when querying.
It also makes it easy to start the implementation with faked data.
Price history

```json
[
  {
	wineName: "wine1"
	selling_site: "selling_site1"
	price: 20.5
	date: "25-08-2023 13:10:00"
  }
]
```

A price is associated with a selling site and a timestamp.
The price history is updated each time the wine database is updated.

## Documentation

Having a documentation following [OpenAPI](https://www.openapis.org/) could be a good idea.


## Technical Stack

### Tests

We can choose between RSpec and Minitest.
I choose Minitest to keep it simple and use the default tool.
However, moving to RSpec seems to be a good idea depending on the team habits and the size of the project.
RSpec could be a better way of writing specifications through tests.

### Steps

```shell
rails new energie-vin --api
```


name: "my wine 1",
	lower_price: 20.5,
	highest_price: 21.5,
	prices: [
  	{
    	selling_site: "selling_site 1",
    	price: 20.5,
  	},
  	{
    	selling_site: "selling_site 2",
    	price: 21.5,
  	},
	],
	average_rating: sum(ratings)/len(ratings)
	ratings: [
  	4.5,
  	5
	]


Let's generate a first basic model.

```shell
rails generate model Wine \
name:string \
lowest_price:decimal \
highest_price:decimal \
average_rating:decimal
```

I hesitated to use float for the notation but I prefer to keep decimal for the precision of the operations to calculate the average.

Apply the model:
```shell
rails db:migrate
```

Add the Wine model validation by updating the model and adding unit tests.


Generate the controller:

```shell
rails generate controller Api::V1::Wines
```

Update `config/routes.rb`:
Update `app/controllers/api/v1/wines_controller.rb`.
Create a sample data by editing `db/seeds.rb`.
Add tests.

Launch the tests
```shell
rails test
```

Launch the server
```shell
rails server
```

Test the API:
```shell
curl -X GET "http://localhost:3000/api/v1/wines?price_min=10&price_max=25"
```

Create the rating model
```shell
rails generate model Rating value:decimal expert_id:integer wine:belongs_to
```

After updating model and controller, I had a lot of issue to write the tests.  
I was confusing with the url helper.
I thought I have to use `api_v1_wine_ratings_url` but thanks to ```rails routes | grep api```, I found that the correct helper is `ratings_api_v1_wine_url`.


```shell
curl -d '{"rating":{"value": 8,"wine": 1,"expert_id":1}}' -X POST "localhost:3000/api/v1/wines/1/ratings" | jq
```
```shell
curl -X DELETE "http://localhost:3000/api/v1/wines/1/ratings/1"
```

Now, what could be an easy way to add prices ref for a wine?
We have to create a Model Price that will store a Price for a wine with a seller_site and a timestamp to know the last update.
One way of improvment is to have a reference to a Seller Model.

Create Price model
```shell
rails generate model Price wine:belongs_to seller_site:string price:decimal fetched_at:datetime
```

Apply migration

```shell
rails db:migrate
```

Add Price relation to the Wine model.

Create a PriceHistory model.
Price represent the current price and PriceHistory keep all prices creation/update.

```shell
rails generate model PriceHistory wine:belongs_to seller_site:string price:decimal
```

To keep it simple, lets create crud api to manage a price.
each creation/update of a price should update the price accordingly,
and fill the price history.

generates the price controller
```shell
rails generate controller Api::V1::Prices
```

Now, each time a price is created/updated, the price is checked to update to wine.lowest_price and the wine.highest_price.
It does not work for price destroy but could be an enhancement.
The price modifications should happen during the data fetch, but I chose to add an API endpoint in the first step.
Similarly, each price creation/update adds a new entry in the PriceHistory table.
I chose to create another table because the live cycle of the current price and a "log" table are completely different. It would be easier to improve the behavior with this separate table.


After adding curl examples and documentation, I think it is the good time to add the openAPI spec and a user friendly way to expose it.
I used chatGPT to generate the specification from the controllers code.
After some fails, I used the redocly command to generate the html from the spec and put it in the public directory.
It seems to be the simplest first step to document the API with OpenAPI spec.


# Improvments

* Add GUI
* API
  * add a job to fetch wine data from external source
  * notification on search
  * add pagination on list
  * Enhance openAPI specification
    * linting
  * user management
    * authentication
	* authorization
  * token management
  * secure app
	* check field use to search (strong parameter and validation)
	* use app id instead of bdd ids
* integrate a "real" database in production like Postgresql
* observability
  * add logs
  * add metrics
  * add tracing
* test
  * improve existing tests
  * add integration tests
  * migrate to rspec and generate test from openAPI spec
  * add code covering
* Add a documentation

# Resources

* [Rails getting started](https://guides.rubyonrails.org/getting_started.html)
* [Create rails API App](https://guides.rubyonrails.org/api_app.html)
* [Testing](https://guides.rubyonrails.org/testing.html)
* https://github.com/rspec/rspec-rails
* https://www.betterspecs.org/
* https://www.reddit.com/r/rails/



