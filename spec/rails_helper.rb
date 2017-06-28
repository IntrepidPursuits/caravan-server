ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "date"
require "rspec/rails"
require "spec_helper"
require "support/factory_girl"
require "warden"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.include Helpers::Requests, type: :request
  config.include Helpers::RequestExpectations
  config.include Warden::Test::Helpers
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
