require 'pry'
require 'sinatra/activerecord'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect # Force the "expect" syntax
  end

  config.fail_fast = true

  config.before { FileUtils.mkdir_p("tmp") }
  config.after  { FileUtils.rm_rf("tmp") }
end
