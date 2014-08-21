require 'test_helper'

# See https://github.com/metaskills/minitest-spec-rails#test-styles
class IntegrationTest < ActionDispatch::IntegrationTest

  describe 'the home page' do
    before do
      visit home_path
    end

    it 'displays "home page"' do
      page.must_have_content 'home page'
    end

    it 'display the main menu' do
      page.must_have_selector 'nav#main-menu'
    end
  
    describe 'when the user is not signed in' do
      # TODO: how to assert that the user is not signed in here?
      it 'has a sign up link' do
        page.must_have_link 'sign up'
      end
    end
    
    describe 'when the user is signed in' do
      it 'does not have a sign up link'
    end
  end
  
  describe 'the sign up link' do
    describe 'when it is clicked' do
      before do
        visit home_path
        click_link 'sign up'
      end
      
      it 'displays the sign up page' do
        current_path.must_equal new_user_path
      end
    end
  end
  
  describe 'the main menu' do
    before do
      visit home_path
    end

    it 'has a link to the home page' do
      within 'nav#main-menu' do
        page.must_have_link 'Biodb'
      end
    end
    
    # describe 'when the user is signed in' do
    #   before do
    #     visit home_path
    #     fill_in 'Email', :with => 'user@example.com'
    #     fill_in 'Password', :with => 'password'
    #     click_button 'Sign in'
    #   end
    #
    #   it 'has a sign out link' do
    #     within 'nav#main-menu' do
    #       page.must_have_link 'Sign out'
    #     end
    #   end
    # end
  end

end
