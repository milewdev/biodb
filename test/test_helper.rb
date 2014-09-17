# Warning: SimpleCov.start must be called before any application code is required
# hence it should remain at the top of this file.
# See https://coveralls.io/docs/ruby
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'


# TODO: these either need to go somewhere else or most of them
# should be deleted.
# See http://stackoverflow.com/a/16363159
def black(text)          ; "\033[30m#{text}\033[0m" ; end
def red(text)            ; "\033[31m#{text}\033[0m" ; end
def green(text)          ; "\033[32m#{text}\033[0m" ; end
def brown(text)          ; "\033[33m#{text}\033[0m" ; end
def blue(text)           ; "\033[34m#{text}\033[0m" ; end
def magenta(text)        ; "\033[35m#{text}\033[0m" ; end
def cyan(text)           ; "\033[36m#{text}\033[0m" ; end
def gray(text)           ; "\033[37m#{text}\033[0m" ; end
def bg_black(text)       ; "\033[40m#{text}\033[0m" ; end
def bg_red(text)         ; "\033[41m#{text}\033[0m" ; end
def bg_green(text)       ; "\033[42m#{text}\033[0m" ; end
def bg_brown(text)       ; "\033[43m#{text}\033[0m" ; end
def bg_blue(text)        ; "\033[44m#{text}\033[0m" ; end
def bg_magenta(text)     ; "\033[45m#{text}\033[0m" ; end
def bg_cyan(text)        ; "\033[46m#{text}\033[0m" ; end
def bg_gray(text)        ; "\033[47m#{text}\033[0m" ; end
def bold(text)           ; "\033[1m#{text}\033[22m" ; end
def reverse_color(text)  ; "\033[7m#{text}\033[27m" ; end

def debug(message)
  Rails::logger.debug bold(green(message))
end


debug "SimpleCov::VERSION: #{SimpleCov::VERSION}"
debug "Coveralls::VERSION: #{Coveralls::VERSION}"


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# See https://github.com/seattlerb/minitest
require 'minitest/spec'
debug "Minitest::VERSION: #{Minitest::VERSION}"

# See https://github.com/freerange/mocha#rails
require 'mocha/mini_test'
debug "Mocha::VERSION: #{Mocha::VERSION}"

# See https://github.com/jnicklas/capybara#setup
require 'capybara/rails'
debug "Capybara::VERSION: #{Capybara::VERSION}"

# See https://github.com/teampoltergeist/poltergeist#installation
require 'capybara/poltergeist'
# TODO: fix this when Poltergeist build is no longer failing
# debug "Capybara::Poltergeist::VERSION: #{Capybara::Poltergeist::VERSION}"

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

  # Additional custom utilities to make the tests dry and easier to read.
  include IntegrationHelper

  # It looks like using transactions to roll back the test database (to improve 
  # test speed) does not work for integration tests.   The test that holds the
  # transaction to be rolled back runs in a different thread than the one which
  # services browser (poltergeist) requests that make changes to the database.
  # The latter runs in a different transaction and does not get rolled back.
  # This leaves the database in an 'unknown' state between tests and the result
  # is Erratic Tests due to Interacting Tests.
  # See http://api.rubyonrails.org/v3.2.13/classes/ActiveRecord/Fixtures.html
  debug "disabling transactional fixtures"
  self.use_transactional_fixtures = false

  before do
    # Use a headless browser driver for integration tests.
    # See https://github.com/jnicklas/capybara#selecting-the-driver
    debug "switching Capybara to polergeist headless browser (was #{Capybara.current_driver})"
    Capybara.current_driver = :poltergeist
  end
  
  after do
    # TODO: document this
    # page.driver.reset!              # real: 3m41.154s, user: 0m0.136s, sys: 0m0.073s
    stub_onbeforeunload               # real: 1m13.246s, user: 0m0.131s, sys: 0m0.069s
    
    # Restore the default browser driver as we use a headless browser only for
    # the integration tests.
    Capybara.use_default_driver
    debug "switching Capybara to default driver (#{Capybara.current_driver})"
  end
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
# debug "switching Capybara to server_port 4000"
