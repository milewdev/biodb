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
    it 'does not have a save button' do
      page.wont_have_css SaveButtonSelector
    end
  end
  
  describe 'when a user is signed in' do
    before do
      sign_in :generic_user
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
        page.must_have_css 'input[type="checkbox"]'   # TODO: remove hard coding here and anywhere else
        page.must_have_content 'edit mode'
      end
    end
    it 'has a save button' do
      page.must_have_css SaveButtonSelector           # TODO: how about must_exist(SaveButtonSelector)
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
      sign_in :generic_user
    end
    describe 'when a user first logs in' do
      it 'is not checked' do
        within 'header nav' do    # TODO: use within_main_menu or within main_menu
          page.wont_have_checked_field 'edit mode'
        end
      end
    end
  end
  
  describe 'the save button' do
    describe 'when there are no unsaved changes' do
      before do
        sign_in :generic_user
        visit home_path
      end
      it 'is disabled' do
        save_button.disabled?.must_equal true
      end
    end
    
    describe 'when there are unsaved changes' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in :generic_user
        visit home_path
        stub_onbeforeunload
        use_edit_mode
        title.native.send_keys :End, change
      end
      it 'is enabled' do
        save_button.disabled?.must_equal false
      end
    end
    
    describe 'when it is pressed' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in :generic_user
        visit home_path
        use_edit_mode
        title.native.send_keys :End, change
        save_button.click
        
        # TODO: is there a better way to wait for ajax to finish?
        # Yes: search for something that changes after the update is complete (e.g. save button dimmed); in this 
        # way capybara will handle the waiting/sleeping.
        # See https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends
        sleep(0.1)
      end
      it 'saves changes to the server' do
        stale_user = users(:generic_user)
        fresh_user = User.find(stale_user.id)
        fresh_user.title.must_equal stale_user.title + change
      end
    end
  end

end
