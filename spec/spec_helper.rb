require 'rack/test'
require 'bundler'
Bundler.require(:test)
require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'
require File.expand_path '../../application.rb', __FILE__

# VCR.configure do |c|
#   c.cassette_library_dir = 'spec/cassettes'
#   c.hook_into :webmock
# end

RSpec.configure do |config|
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  Capybara.app = app

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed

  RspecApiDocumentation.configure do |config|
    config.app = app
    config.format = :json
  end
end
