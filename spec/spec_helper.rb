ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "pundit/rspec"
require "rspec/rails"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }
Dir["support/helpers/*.rb"].each {|file| require file }

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include Helpers::Requests, type: :request
  config.include ExternalGoogleRequests
  config.include ExternalTwitterRequests
  config.include LocationSimulatorRequests
  config.include JsonSpec::Helpers

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

WebMock.disable_net_connect!(allow_localhost: true)
