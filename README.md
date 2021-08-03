# Frankfurter

[![Build](https://github.com/hakanensari/frankfurter/workflows/build/badge.svg)](https://github.com/hakanensari/frankfurter/actions)

[Frankfurter](https://www.frankfurter.app) is a free and open-source currency data API that tracks reference exchange rates published by the European Central Bank.

`api.frankfurter.app` hosts a public instance of the API.

## Getting Started

Get the latest exchange rates.

```
https://api.frankfurter.app/latest
```

Get rates for a past date.

```
https://api.frankfurter.app/2000-01-03
```

Get rates for a period.

```http
https://api.frankfurter.app/2010-01-01..2010-01-31
```

For more examples, read the [docs](https://www.frankfurter.app/docs).

## Deployment

You can self-host Frankfurter with Docker.

### Using existing PostgreSQL 

```bash
docker build -t frankfurter .

docker run -d -p 8080:8080 \
  -e "DATABASE_URL=<postgres_url>" \
  --name frankfurter frankfurter
```

Check out http://localhost:3000/latest

### Using Docker Compose

```bash
docker compose up
```

Check out http://localhost:3000/latest

To connect to the database instance; `psql -h db -d frankfurtdb -U postgresuser -W`

### Using local, Dockerized PostgreSQL

```bash
docker pull postgres
docker run --name postgres \
  -p 5432:5432 \
  -e POSTGRES_DB=frankfurtdb \
  -e POSTGRES_USER=postgresuser \
  -e POSTGRES_PASSWORD=postgrespw \
  -d postgres 

docker build -t frankfurter .

docker run -d -p 3000:3000 \
  -e "DATABASE_URL=postgres://postgresuser:postgrespw@host.docker.internal/frankfurtdb" \
  -e PORT=3000 \
  --name frankfurter \
  -it frankfurter
```

Check out http://localhost:3000/latest

## Miscellaneous

Frankfurter was known as Fixer between 2012 and 2018. After selling the original domain, I relaunched under this name.
