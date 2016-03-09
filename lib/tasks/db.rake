namespace :db do
  desc 'Dumps the production database on heroku to db/ferris.dump'
  task :pull => :environment do
    Bundler.with_clean_env {
      cmd = 'heroku pg:backups capture'
      sh cmd

      cmd = 'curl -o db/ferris.dump `heroku pg:backups public-url`'
      sh cmd
    }
  end

  desc 'Loads production database backup onto local environment'
  task :load => :environment do
    db = ActiveRecord::Base.connection_config[:database]
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{db} #{Rails.root}/db/ferris.dump"
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    sh cmd
  end
end