# See https://coveralls.io/docs/ruby
require 'coveralls'
Coveralls.wear!('rails')

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'

# See https://github.com/freerange/mocha#rails
require 'mocha/mini_test'

# See https://github.com/jnicklas/capybara#setup
require 'capybara/rails'

# See https://github.com/teampoltergeist/poltergeist#installation
require 'capybara/poltergeist'

# These are integration test helper methods.  To use them, do:
#
#   class MyIntegrationTest < ActionDispatch::IntegrationTest  
#     include IntegrationHelper
#     ...
#   end
# 
require 'integration_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# See https://github.com/jnicklas/capybara#using-capybara-with-testunit
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  
  def enable_js
    Capybara.current_driver = :poltergeist
  end
  
  def disable_js
    Capybara.use_default_driver
  end

end
