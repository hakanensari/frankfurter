# Frankfurter

[![Build](https://github.com/hakanensari/frankfurter/workflows/build/badge.svg)](https://github.com/hakanensari/frankfurter/actions)

> ⚠️ **Note**: This is the legacy version of Frankfurter with the original unversioned API.
> For the new versioned API, please visit the `main` branch.
>
> - Legacy API Docker image: `hakanensari/frankfurter`
> - New API Docker image: `lineofflight/frankfurter`

[Frankfurter](https://frankfurter.dev) is a free and open-source currency data API that tracks reference exchange rates published by the European Central Bank.

## Deployment

### Using Docker

The simplest way to run Frankfurter is with Docker:

```bash
docker run -d -p 8080:8080 \
  -e "DATABASE_URL=<postgres_url>" \
  --name frankfurter hakanensari/frankfurter
```

### Using Docker Compose

For a complete setup including PostgreSQL:

1. Copy the [docker-compose.yml](./docker-compose.yml) file
2. Run:
```bash
docker compose up --wait
```

## Contributing

Frankfurter is built with Ruby. To contribute:

1. Fork.
2. Install dependencies with `bundle install`.
3. Run tests with `bundle exec rake`.
4. Push your changes to a feature branch.
5. Open a pull request.
