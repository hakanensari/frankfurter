# frozen_string_literal: true

namespace :db do
  desc 'Run database migrations'
  task migrate: :environment do
    Sequel.extension(:migration)
    db = Sequel::DATABASES.first
    dir = App.root.join('db/migrate')
    opts = {}
    opts.update(target: ENV['VERSION'].to_i) if ENV['VERSION']

    Sequel::IntegerMigrator.new(db, dir, opts).run
  end

  task prepare: %w[db:migrate rates:all]

  namespace :test do
    task :prepare do
      ENV['APP_ENV'] ||= 'test'
      Rake::Task['db:migrate'].invoke
      Rake::Task['rates:seed_with_saved_data'].invoke
    end
  end
end
