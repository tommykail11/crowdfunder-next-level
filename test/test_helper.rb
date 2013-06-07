ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  teardown do 
    DatabaseCleaner.clean
  end
end

DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  Capybara.app = CrowdfunderNextLevel::Application
  # To change the Capybara driver to webkit when wanted
  Capybara.javascript_driver = :webkit

  self.use_transactional_fixtures = false 

  setup do
    reset_email
  end

  # This happens at the end of every test
  teardown do
    DatabaseCleaner.clean       # Erase what we put into the database during the tests
    Capybara.reset_sessions!    # Reset browser session
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  # This is a helper method we can call anywhere in the tests
  def setup_signed_in_user
    pass = "this-is-a-password"
    user = FactoryGirl.create :user, password: pass
    visit '/session/new'

    fill_in "email", with: user.email
    fill_in "password", with: pass
    click_button "Login"

    # No asserts because testing is not done inside of a helper method
    user
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end
 
  def reset_email
    ActionMailer::Base.deliveries = []
  end
end