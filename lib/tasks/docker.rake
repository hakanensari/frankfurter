# frozen_string_literal: true

namespace :docker do
  namespace :development do
    desc 'Build and start services in development'
    task :start do
      `docker-compose up -d`
    end
  end

  namespace :production do
    desc 'Build or rebuild and start services in production'
    task :start do
      `docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull && docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d`
    end
  end
end
