require 'test_helper'

# TODO: rename HomePageTest to TitleIntegrationTest
class HomePageTest < ActionDispatch::IntegrationTest

  describe 'a user\'s title' do
    before do
      Rails.logger.level = 0    # 0 means :debug
      enable_js
    end

    describe 'when a user is not signed in' do
      before do
        sign_out
        visit home_path
      end
      it 'is not displayed' do
        page.wont_have_css TitleSelector
      end
    end

    describe 'when there is no title' do
      before do
        sign_in users(:no_title)
      end

      describe 'when starting in view mode' do
        it 'hides the title' do
          wont_be_visible(title)  # TODO: change to user_title everywhere
        end
      end

      describe 'after switching to edit mode' do
        before do
          use_edit_mode
        end
        it 'shows the title' do
          must_be_visible(title)
        end
      end

      describe 'after switching back to view mode' do
        before do
          use_edit_mode
          use_view_mode
        end
        it 'hides the title' do
          wont_be_visible(title)
        end
      end
    end

    describe 'when there is a title' do
      before do
        sign_in users(:with_title)
      end

      describe 'when starting in view mode' do
        it 'shows the title' do
          must_be_visible(title)
        end
        it 'disables the save button' do
          save_button.disabled?.must_equal true
        end
      end

      describe 'after switching to edit mode' do
        before do
          use_edit_mode
        end
        it 'still shows the title' do
          must_be_visible(title)
        end
      end

      describe 'after switching back to view mode' do
        before do
          use_edit_mode
          use_view_mode
        end
        it 'still shows the title' do
          must_be_visible(title)
        end
      end
    end

    describe 'when the user types something' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in users(:title_will_be_changed_by_tests)
        use_edit_mode
        title.native.send_keys :End, change
        stub_onbeforeunload
      end
      it 'changes the title' do
        title.text.must_equal "#{users(:title_will_be_changed_by_tests).title}#{change}"
      end
      it 'enables the save button' do
        save_button.disabled?.must_equal false
      end
    end

    describe 'when the user deletes the title and then switches to view mode' do
      before do
        sign_in users(:title_will_be_deleted_by_a_test)
        use_edit_mode
        delete_inner_text title
        use_view_mode
      end
      it 'hides the title' do
        wont_be_visible(title)
      end
    end

    describe 'when in view mode' do
      before do
        sign_in users(:with_title)
      end
      it 'has the class view-mode' do
        must_have_class(title, 'view-mode')
      end
      it 'does not have the class edit-mode' do
        wont_have_class(title, 'edit-mode')
      end
    end

    describe 'when in edit mode' do
      before do
        sign_in users(:with_title)
        use_edit_mode
      end
      it 'has the class edit-mode' do
        must_have_class(title, 'edit-mode')
      end
      it 'does not have the class view-mode' do
        wont_have_class(title, 'view-mode')
      end
    end

    describe 'when a link is clicked and there are unsaved changes' do
      let(:change) { "_#{__LINE__}" }
      let(:onbeforeunload_result) do
        sign_in users(:title_will_be_changed_by_tests)
        use_edit_mode
        title.native.send_keys :End, change
        capture_onbeforeunload { home_link.click }
      end
      it 'prompts the user about unsaved changes' do
        onbeforeunload_result.must_equal 'Data you have entered may not be saved.'
      end
    end

    describe 'when a link is clicked and there are no unsaved changes' do
      let(:onbeforeunload_result) do
        sign_in users(:generic)
        capture_onbeforeunload { home_link.click }
      end
      it 'does not prompt the user about unsaved changes' do
        onbeforeunload_result.must_equal 'undefined'
      end
    end
    
    describe 'when leaving edit mode and there are unsaved changes to the title' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in users(:title_will_be_changed_by_tests)
        use_edit_mode
        title.native.send_keys :End, change
        use_view_mode
        
        # TODO: is there a better way to wait for ajax to finish?
        # Yes: search for something that changes after the update is complete (e.g. save button dimmed); in this 
        # way capybara will handle the waiting/sleeping.
        # See https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends
        sleep(0.1)
      end
      it 'immediately saves the changes to the server' do
        stale_user = users(:title_will_be_changed_by_tests)
        fresh_user = User.find(stale_user.id)
        fresh_user.title.must_equal stale_user.title + change
      end
    end
    
    describe 'when leaving edit mode and there are no unsaved changes' do
      before do
        sign_in users(:generic)
        use_edit_mode
        use_view_mode
        sleep(0.1)    # TODO: see TODO in test above this one
      end
      it 'does not save anything to the server' do
        stale_user = users(:generic)
        fresh_user = User.find(stale_user.id)
        fresh_user.title.must_equal stale_user.title
      end
    end

    after do
      disable_js
    end
  end
end
