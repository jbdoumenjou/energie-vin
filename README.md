# Energie Vin

![Tests](https://github.com/jbdoumenjou/energie-vin/actions/workflows/test-unit.yaml/badge.svg)
![Linting](https://github.com/jbdoumenjou/energie-vin/actions/workflows/lint.yaml/badge.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jbdoumenjou/energie-vin/blob/main/LICENSE.md)

A search platform referencing wines sold on specialized sites.
The data (bottle properties, price and sales site) can be retrieved from an external service.

To set itself apart from the competition,
the platform aims to give pride of place to the expert with the possibility of integrating their tasting notes.

The wines sold can be easily retrieved,
ranked by best average tasting notes,
and priced within the range set by the user.


# Usage

## locally

Run the server

```shell
rails db:migrate && rails db:seed && rails server
```

Test the Wine API

```
curl -X GET "http://localhost:3000/api/v1/wines?price_min=1&price_max=14" | jq
```

## Deployment

The main branch of this project is deployed via [Koyeb](https://www.koyeb.com/)

```shell
curl -X GET "https://energie-vin-jbd.koyeb.app/api/v1/wines?price_min=1&price_max=14" | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   175    0   175    0     0   1251      0 --:--:-- --:--:-- --:--:--  1258
[
  {
    "id": 2,
    "name": "Wine 2",
    "lowest_price": "10.75",
    "highest_price": "20.0",
    "average_rating": "3.8",
    "created_at": "2023-08-28T17:01:52.334Z",
    "updated_at": "2023-08-28T17:01:52.334Z"
  }
]
```
