require 'shoulda-matchers'
require 'rack/test'
require 'database_cleaner/active_record'
require 'factory_bot'
require 'webmock/rspec'
require 'pry-byebug'

require_relative '../boot'
require_relative 'controllers/application_spec'

require_all 'spec/contexts/*.rb'

module Helpers
  def parsed_body(symbolize: false)
    JSON.parse(last_response.body, symbolize_names: symbolize)
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.include Controllers::Test
  config.include Helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end

ActiveRecord::Base.logger = nil
