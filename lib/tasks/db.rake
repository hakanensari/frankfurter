# frozen_string_literal: true

namespace :db do
  desc "Run database migrations"
  task migrate: :environment do
    Sequel.extension(:migration)
    db = Sequel::DATABASES.first
    dir = App.root.join("db/migrate")
    opts = {}
    opts.update(target: ENV["VERSION"].to_i) if ENV["VERSION"]

    Sequel::IntegerMigrator.new(db, dir, opts).run
  end

  desc "Run database migrations and seed data"
  task prepare: ["db:migrate", "rates:all"]

  namespace :test do
    desc "Run database migrations and seed with saved data"
    task :prepare do
      ENV["APP_ENV"] ||= "test"
      Rake::Task["db:migrate"].invoke
      Rake::Task["rates:seed_with_saved_data"].invoke
    end
  end
end
