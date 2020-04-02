# Frankfurter

[![Build](https://github.com/hakanensari/frankfurter/workflows/build/badge.svg)](https://github.com/hakanensari/frankfurter/actions)

[Frankfurter](https://www.frankfurter.app) is a free and open-source currency data API that tracks reference exchange rates published by the European Central Bank.

I host a public instance of the API at `api.frankfurter.app`.

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

For more examples, read the [docs](https://www.frankfurter.app/docs).

## Deployment

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/hakanensari/frankfurter)

You can self-host Frankfurter with Heroku or Docker.

```bash
docker run -d -p 8080:8080 \
  -e "DATABASE_URL=<postgres_url>" \
  --name frankfurter hakanensari/frankfurter
```

Check out the [website](https://www.frankfurter.app/docs#deployment) for a more detailed walkthrough.

## Miscellaneous

Frankfurter was known as Fixer between 2012 and 2018. After selling the original domain, I relaunched under this name.
