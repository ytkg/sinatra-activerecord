case ActiveRecord::VERSION::MAJOR
when 4

  seed_loader = Object.new
  seed_loader.instance_eval do
    def load_seed
      load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
    end
  end

  ActiveRecord::Tasks::DatabaseTasks.tap do |config|
    config.root                   = Rake.application.original_dir
    config.env                    = ENV["RACK_ENV"] || "development"
    config.db_dir                 = "db"
    config.migrations_paths       = ["db/migrate"]
    config.fixtures_path          = "test/fixtures"
    config.seed_loader            = seed_loader
    config.database_configuration = ActiveRecord::Base.configurations
  end

when 3

  require "active_support/string_inquirer"

  module Rails
    extend self

    def root
      Pathname.new(Rake.application.original_dir)
    end

    def env
      ActiveSupport::StringInquirer.new(ENV["RACK_ENV"] || "development")
    end

    def application
      seed_loader = Object.new
      seed_loader.instance_eval do
        def load_seed
          load "db/seeds.rb"
        end
      end
      seed_loader
    end
  end

end

ActiveRecord::Base.logger = nil

load 'sinatra/activerecord/tasks.rake'
