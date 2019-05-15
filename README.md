# Frankfurter

[![Build](https://travis-ci.org/hakanensari/frankfurter.svg?branch=master)](https://travis-ci.org/hakanensari/frankfurter.svg?branch=master)

[Frankfurter](https://www.frankfurter.app) is a free, open-source currency data API that tracks reference exchange rates published by the European Central Bank.

Frankfurter was known as Fixer until March 2018, when I sold the domain. After the buyer abandoned the underlying open-source project, I relaunched under this name.

## Getting Started

Get the latest exchange rates.

```http
GET /latest HTTP/1.1
```

Get rates for a past date.

```http
GET /2000-01-03 HTTP/1.1
```

Get rates for a period.

```http
GET /2010-01-01..2010-01-31 HTTP/1.1
```

For further examples, read the [docs](https://www.frankfurter.app/docs#usage).

## Deployment

You can self-host Frankfurter easily with Docker.

```bash
docker run -d -p 8080:8080 \
  -e "DATABASE_URL=<postgres_url>" \
  --name frankfurter hakanensari/frankfurter
```

Check out the [website](https://www.frankfurter.app/docs#deployment) for a more detailed walkthrough.
