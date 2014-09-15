# See https://coveralls.io/docs/ruby
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
gem 'minitest'
require 'minitest/spec'

# See https://github.com/freerange/mocha#rails
require 'mocha/mini_test'

# See https://github.com/jnicklas/capybara#setup
require 'capybara/rails'

# See https://github.com/teampoltergeist/poltergeist#installation
require 'capybara/poltergeist'

# So that IntegrationHelper can be included in ActionDispatch::IntegrationTest (see below).
require 'integration_helper'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  # See https://github.com/jnicklas/capybara#using-capybara-with-testunit
  include Capybara::DSL

  # Additional custom utilities to make the test dry and easier to read.
  include IntegrationHelper
end


# Uncomment if you want to set Poltergeist options (e.g. debug: true).
# See https://github.com/teampoltergeist/poltergeist#customization
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, debug: true)
# end

# Uncomment to if you want to, say, sniff the network traffic between PhantonJS (a
# headless browser) and rails.
# See http://rubydoc.info/github/jnicklas/capybara/master/Capybara
# Capybara.server_port = 4000


# See https://github.com/teampoltergeist/poltergeist#installation
Capybara.current_driver = :poltergeist
