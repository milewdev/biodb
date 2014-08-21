require 'test_helper'

# See https://github.com/metaskills/minitest-spec-rails#test-styles
class IntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'signing in' do
    after do
      # TODO: use logout
      visit '/'
      click_link 'sign out' if page.has_link? 'sign out'
    end
    
    it 'allows a user with an existing account to sign in' do
      visit home_path
      click_link 'sign in'
      fill_in 'Email', with: 'name1@company.com'
      fill_in 'Password', with: 'Password1234'
      click_button 'sign in'
      current_path.must_equal home_path
    end
  end

end
