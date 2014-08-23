require 'test_helper'


# See https://github.com/metaskills/minitest-spec-rails#test-styles
class SignUpTest < ActionDispatch::IntegrationTest

  describe 'a user signing up' do
    it '' do      
      visit home_path
      current_path.must_equal home_path
      click_link 'sign up'
      current_path.must_equal new_user_path
      fill_in 'Email', with: 'name@company.com'
      fill_in 'Password', with: 'Password1234'
      fill_in 'Password confirmation', with: 'Password1234'
      click_button 'Create User'
      current_path.must_equal home_path
      click_link 'sign out'
      current_path.must_equal home_path
      click_link 'sign in'
      current_path.must_equal new_session_path
      fill_in 'Email', with: 'name@company.com'
      fill_in 'Password', with: 'Password1234'
      click_button 'Sign in'
      current_path.must_equal home_path
      click_link 'sign out'
      current_path.must_equal home_path
    end
  end
  
end
