require "active_support/core_ext/string/strip"
require "pathname"

load "active_record/railties/databases.rake"

namespace :db do
  desc "Create a migration (parameters: NAME, VERSION)"
  task :create_migration do
    unless ENV["NAME"]
      puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
      exit
    end

    name    = ENV["NAME"]
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

    filename = "#{version}_#{name}.rb"
    dirname  = ActiveRecord::Migrator.migrations_path
    path     = Pathname(File.join(dirname, filename))

    path.dirname.mkpath
    path.write <<-MIGRATION.strip_heredoc
      class #{name.camelize} < ActiveRecord::Migration
        def change
        end
      end
    MIGRATION

    puts path
  end

  task :environment

  Rake::Task["db:test:deprecated"].clear if Rake::Task.task_defined?("db:test:deprecated")

  if ActiveRecord::VERSION::MAJOR == 3
    Rake::Task["db:load_config"].clear
    task :rails_env
  end
end
