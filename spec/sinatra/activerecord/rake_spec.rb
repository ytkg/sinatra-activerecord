require 'spec_helper'
require 'fileutils'

module MigrationWithQuiet
  def migrate(*args)
    suppress_messages do
      super(*args)
    end
  end
end

ActiveRecord::Migration.send(:prepend, MigrationWithQuiet)

RSpec.describe "the rake tasks" do
  before do
    Class.new(Sinatra::Base) do
      register Sinatra::ActiveRecordExtension
      set :database, {adapter: "sqlite3", database: "tmp/foo.sqlite3"}
    end

    FileUtils.mkdir_p "db"
    FileUtils.touch "db/seeds.rb"

    require 'rake'
    require 'sinatra/activerecord/rake'

    module TaskWithReenable
      def invoke
        super
        reenable
      end
    end

    Rake::Task.send(:prepend, TaskWithReenable)
  end

  after do
    FileUtils.rm_rf "db"
  end

  it "has all the rake tasks working" do
    ENV["NAME"] = "create_users"

    Rake::Task["db:create"].invoke
    Rake::Task["db:create_migration"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:migrate:redo"].invoke
    Rake::Task["db:reset"].invoke
    Rake::Task["db:seed"].invoke

    ENV.delete("NAME")
  end
end
