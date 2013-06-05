ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  Capybara.app = CrowdfunderNextLevel::Application
  # To change the Capybara driver to webkit when wanted.
  Capybara.javascript_driver = :webkit

  self.use_transactional_fixtures = false

  # This happens at the end of every test.
  teardown do
    DatabaseCleaner.clean       # Erase what we put into the database during tests
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  # This is a helper method we can call anywhere in the tests
  def setup_signed_in_user
    pass = "this_is_a_password"
    user = FactoryGirl.create :user, password: pass
    visit = '/session/new'

    fill_in "email", with: user.email
    fill_in "password", with: pass
    click_button "Login"

    # No asserts becaus testing is not done inside of a helper method
  end
end
