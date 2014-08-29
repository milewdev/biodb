require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  
  def sign_in
    sign_out    
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => users(:name1).email
    fill_in 'Password', :with => 'Password1234'
    click_button 'Sign in'
  end
  
  def sign_out
    click_link 'sign out' if page.has_link? 'sign out'
  end
  
  def enable_js
    Capybara.current_driver = :webkit
  end
  
  def disable_js
    Capybara.use_default_driver
  end

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
    end    
    it 'does not have a sign up link' do
      page.wont_have_link 'sign up'
    end
    it 'does not have a sign in link' do
      page.wont_have_link 'sign in'
    end
    it 'displays the user\'s email address' do
      page.must_have_content users(:name1).email
    end
    after do
      sign_out
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
  
  describe 'the highlight list' do
    before do
      enable_js
      sign_in
    end
    focus
    it 'displays all the highlights of the logged in user' do
      visit home_path
      users(:name1).highlights.each do |highlight|
        find("textarea[data-id='#{highlight.id}']").value.must_equal highlight.content
      end
    end
    after do
      sign_out
      disable_js
    end
  end

end
