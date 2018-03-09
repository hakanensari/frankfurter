# Fixer

[![Travis](https://travis-ci.org/hakanensari/fixer.svg)](https://travis-ci.org/hakanensari/fixer)

Fixer is a free API for current and historical foreign exchange rates [published by the European Central Bank](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

Rates are updated around 4PM CET every working day.

## Usage

Get the latest foreign exchange rates.

```http
GET /latest
```

Get historical rates for any day since 1999.

```http
GET /2000-01-03
```

Rates quote against the Euro by default. Quote against a different currency.

```http
GET /latest?from=USD
```

Request specific exchange rates.

```http
GET /latest?to=GBP
```

Change the amount requested.

```http
GET /latest?amount=100
```

The primary use case is client side. For instance, with [money.js](https://openexchangerates.github.io/money.js/) in the browser

```js
let demo = () => {
  let rate = fx(1).from("GBP").to("USD")
  alert("£1 = $" + rate.toFixed(4))
}

fetch('https://yourdomain.com/latest')
  .then((resp) => resp.json())
  .then((data) => fx.rates = data.rates)
  .then(demo)
```

## Installation

To build locally, type

```bash
docker-compose up -d
```

Now you can access the API at

```
http://localhost:8080
```

In production, first create a `.env` file based on [`.env.example`](.env.example). Then, run with

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

To update to a newer image

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Within a few minutes, you will be able to access the API at

```
https://yourdomain.com:8080
```
