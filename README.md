# Frankfurter

[![Build](https://github.com/lineofflight/frankfurter/workflows/build/badge.svg)](https://github.com/lineofflight/frankfurter/actions)

[Frankfurter](https://frankfurter.dev) is a free and open-source currency data API that tracks reference exchange rates published by the European Central Bank.

Check the website for a detailed walkthrough.

## Deployment

### Using Docker

The simplest way to run Frankfurter is with Docker:

```bash
docker run -d -p 8080:8080 lineofflight/frankfurter
```

## Contributing

Frankfurter is built with Ruby. To contribute:

1. Fork.
2. Install dependencies with `bundle install`.
3. Run tests with `bundle exec rake`.
4. Push your changes to a feature branch.
5. Open a pull request.

## Roadmap

- [x] Infrastructure
  - [x] Migrate from PostgreSQL to SQLite for simpler deployment.
  - [x] Add API versioning in URL path.

- [ ] Data Sources
  - [ ] Add support for multiple data providers.
    - [ ] IMF
    - [ ] Other central banks

- [ ] Features
  - [ ] Add GraphQL endpoint.
  - [ ] Deploy as a blockchain oracle.
