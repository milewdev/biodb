require 'test_helper'

class MainMenuTest < ActionDispatch::IntegrationTest

  # TODO: move these methods to somewhere common
  # TODO: method should take user argument
  def sign_in
    sign_out    
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => users(:one).email
    fill_in 'Password', :with => 'Password1234'
    click_button 'sign in'
  end
  
  def sign_out
    click_link 'sign out' if page.has_link? 'sign out'
  end

  describe 'main menu' do
    before do
      visit home_path
    end
    it 'has a link to the home page' do
      within 'nav#main-menu' do
        page.must_have_link 'Biodb'
      end
    end
  end
  
  describe 'when a user is not signed in' do
    it 'does not have a sign out link' do
      page.wont_have_link 'sign out'
    end
  end
  
  describe 'when a user is signed in' do
    before do
      sign_in
    end
    after do
      sign_out
    end
    it 'has a sign out link' do
      within 'nav#main-menu' do
        page.must_have_link 'sign out'
      end
    end
    it 'displays the user\'s email address' do
      within 'nav#main-menu' do
        page.must_have_content users(:one).email
      end
    end
  end
  
end
