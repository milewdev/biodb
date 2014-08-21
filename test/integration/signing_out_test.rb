require 'test_helper'

# See https://github.com/metaskills/minitest-spec-rails#test-styles
class IntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'signing out' do
    before do
      # TODO: use sign_in
      visit home_path
      click_link 'sign in'
      fill_in 'Email', :with => 'name1@company.com'
      fill_in 'Password', :with => 'Password1234'
      click_button 'sign in'
    end
    
    it 'allows a signed in user to sign out' do
      # TODO: assert that user email appears on the menu
      click_link 'sign out'
      current_path.must_equal home_path
      # TODO: assert that the user email does not appear on the menu
    end
  end

end
