require 'test_helper'

# See https://github.com/metaskills/minitest-spec-rails#test-styles
class IntegrationTest < ActionDispatch::IntegrationTest

  describe 'signing up' do
    after do
      # TODO: use sign_out
      click_link 'sign out' if page.has_link? 'sign out'
    end
    
    it 'allows a user to create an account' do
      visit home_path
      click_link 'sign up'
      fill_in 'Email', with: 'name@company.com'
      fill_in 'Password', with: 'Password1234'
      fill_in 'Password confirmation', with: 'Password1234'
      click_button 'Create User'
      current_path.must_equal home_path
    end
  end

end
