require 'test_helper'

class UserAuthenticationFlowTest < ActionDispatch::IntegrationTest

  test "successful registration" do 
    visit "/users/new"
    assert_equal new_user_path, current_path

    # Assert there is a link in the navbar for Sign Up
    assert find('.navbar').has_link?('Sign Up')

    user = FactoryGirl.build(:user) 

    # Fill in the form with the info from user created by FactoryGirl
    fill_in "user[email]", :with => user.email
    fill_in "user[first_name]", :with => user.first_name
    fill_in "user[last_name]", :with => user.last_name
    fill_in "user[password]", :with => user.password
    click_button "Create Account"

    # After submitting the form, should be redirected to root
    assert_equal root_path, current_path
    # There should be a message says "Account Created"
    assert page.has_content?("Account created")
    # And the navbar no longer has a link to Sign Up, but a link to Logout
    assert find('.navbar').has_no_link?('Sign Up')
    assert find('.navbar').has_link?('Logout')
  end

  test "failed registration" do 
    visit "/users/new"
    user = FactoryGirl.build(:user) 

    # Invalid form submission ...
    fill_in "user[email]", :with => user.email
    click_button "Create Account"
    # Should redirect to users_path and ...
    assert_equal users_path, current_path
    # ... no message saying "Account created" should appear
    assert page.has_no_content?("Account created")
  end
end
