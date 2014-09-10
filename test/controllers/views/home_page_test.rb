require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  
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
    it 'does not have an edit mode check box' do
      page.wont_have_css 'header nav input[type="checkbox"]'
      page.wont_have_content 'edit mode'
    end
  end
  
  describe 'when a user is signed in' do
    before do
      sign_in users(:generic)
      visit home_path
    end    
    it 'does not have a sign up link' do
      page.wont_have_link 'sign up'
    end
    it 'does not have a sign in link' do
      page.wont_have_link 'sign in'
    end
    it 'has an edit mode check box' do
      within 'header nav' do
        page.must_have_css 'input[type="checkbox"]'
        page.must_have_content 'edit mode'
      end
    end
  end
  
  describe 'the sign up link' do
    describe 'when it is clicked' do
      before do
        sign_out
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
        sign_out
        visit home_path
        click_link 'sign in'
      end
      it 'displays the sign in page' do
        current_path.must_equal new_session_path
      end
    end
  end
  
  describe 'the edit node check box' do
    before do
      sign_in users(:generic)
    end
    describe 'when a user first logs in' do
      it 'is not checked' do
        within 'header nav' do    # TODO: use within_main_menu or within main_menu
          page.wont_have_checked_field 'edit mode'
        end
      end
    end
  end

end
