require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  include IntegrationHelper
  
  describe 'home page' do
    before do
      visit home_path
    end
    it 'displays the main menu' do
      page.must_have_link 'Biodb'
    end
  end

  describe 'when a user is not signed in' do
    before do
      sign_out
      visit home_path
    end
    it 'has a sign up link' do
      page.must_have_link 'sign up'
    end
    it 'has a sign in link' do
      page.must_have_link 'sign in'
    end
  end
  
  describe 'when a user is signed in' do
    before do
      sign_in
      visit home_path
    end    
    it 'does not have a sign up link' do
      page.wont_have_link 'sign up'
    end
    it 'does not have a sign in link' do
      page.wont_have_link 'sign in'
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
  
  describe 'the sign in link' do
    describe 'when it is clicked' do
      before do
        visit home_path
        click_link 'sign in'
      end
      it 'displays the sign in page' do
        current_path.must_equal new_session_path
      end
    end
  end

end
