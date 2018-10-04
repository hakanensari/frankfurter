# Frankfurter

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/hakanensari/frankfurter)

Frankfurter is a free and open source API for current and historical foreign exchange rates. It tracks data published by the European Central Bank. Rates are updated around 4PM CET every working day.

We host a public instance on `https://frankfurter.app`. Alternatively, you can deploy a private instance using the provided Docker image.


## Examples

Get the current foreign exchange rates.

```http
GET /latest HTTP/1.1
```

Get historical rates for any day since 1999.

```http
GET /2000-01-03 HTTP/1.1
```

Get historical rates for a time period.

```http
GET /2010-01-01..2010-01-31 HTTP/1.1
```

Get historical rates for a time period up to the present.

```http
GET /2010-01-01.. HTTP/1.1
```

Rates quote against the Euro by default. Quote against a different currency.

```http
GET /latest?from=USD HTTP/1.1
```

Request specific exchange rates.

```http
GET /latest?to=USD,GBP HTTP/1.1
```

Convert a specific amount.

```http
GET /latest?amount=1000&from=GBP&to=USD HTTP/1.1
```

With a full list of currencies, time series grow large in size. For better performance, use the to parameter to reduce the response weight.

```http
GET /2016-01-01..2016-12-31?from=GBP&to=USD HTTP/1.1
```

Here we return the current GBP/USD currency pair with JavaScript.

```js
// Fetch and display GBP/USD
fetch('/latest?from=GBP&to=USD')
  .then(resp => resp.json())
  .then((data) => { alert(`GBPUSD = ${data.rates.USD}`); });
```

Cache data whenever possible.

## Deployment

To build locally, type

```bash
docker-compose up -d
```

Now you can access the API at `http://localhost:8080`.

In production, create a [`.env`](.env.example) file and run with

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

To update to a newer image, run

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
```

Within a few minutes, you will access the API at `https://yourdomain.com/`.

[![Travis](https://travis-ci.org/hakanensari/frankfurter.svg)](https://travis-ci.org/hakanensari/frankfurter)
