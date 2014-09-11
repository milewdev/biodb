require 'test_helper'

class NameIntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'a user\'s name' do
    before do
      enable_js
    end
    
    describe 'when a user is not signed in' do
      before do
        sign_out
      end
      it 'is not displayed' do
        page.wont_have_css UserNameSelector
      end
    end
    
    describe 'when the name is missing' do
      before do
        sign_in users(:no_name)
      end
      
      describe 'when in view mode' do
        before do
          use_view_mode
        end
        it 'is hidden' do
          wont_be_visible(user_name)
        end
        it 'is not editable' do
          wont_be_editable(user_name)
        end
      end
      
      describe 'when in edit mode' do
        before do
          use_edit_mode
        end
        it 'is displayed' do
          must_be_visible(user_name)
        end
        it 'is editable' do
          must_be_editable(user_name)
        end
      end
      
      describe 'when switching back to view mode' do
        before do
          use_edit_mode
          use_view_mode
        end
        it 'is hidden' do
          wont_be_visible(user_name)
        end
        it 'is not editable' do
          wont_be_editable(user_name)
        end
      end
    end
    
    describe 'when there is a name' do
      before do
        sign_in users(:with_title)
      end

      describe 'when in view mode' do
        before do
          use_view_mode
        end
        it 'is displayed' do
          must_be_visible(user_name)
        end
        it 'is not editable' do
          wont_be_editable(user_name)
        end
      end
      
      describe 'when in edit mode' do
        before do
          use_edit_mode
        end
        it 'is displayed' do
          must_be_visible(user_name)
        end
        it 'is editable' do
          must_be_editable(user_name)
        end
      end
      
      describe 'when switching back to view mode' do
        before do
          use_edit_mode
          use_view_mode
        end
        it 'is displayed' do
          must_be_visible(user_name)
        end
        it 'is not editable' do
          wont_be_editable(user_name)
        end
      end
    end
    
    describe 'when the user types something' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in users(:name_will_be_changed_by_tests)
        use_edit_mode
        user_name.native.send_keys :End, change
        stub_onbeforeunload     # TODO: this likely should be done by default for all tests, otherwise it adds local noise
      end
      it 'changes the name' do
        user_name.text.must_equal "#{users(:name_will_be_changed_by_tests).name}#{change}"
      end
      it 'enables the save button' do
        save_button.disabled?.must_equal false
      end
    end
    
    describe 'when the user deletes the name and switches back to view mode' do
      before do
        sign_in users(:name_will_be_deleted_by_a_test)
        use_edit_mode
        delete_inner_text user_name
        use_view_mode
      end
      it 'is hidden' do
        wont_be_visible(user_name)
      end
    end
    
    describe 'when data is saved' do
      let(:change) { "_#{__LINE__}" }
      before do
        sign_in users(:name_will_be_changed_by_tests)
        use_edit_mode
        user_name.native.send_keys :End, change
        save_button.click
        sleep(0.1)    # TODO: need a better way ...
      end
      it 'saves the user name to the server' do
        stale_user = users(:name_will_be_changed_by_tests)
        fresh_user = User.find(stale_user.id)
        fresh_user.name.must_equal stale_user.name + change
      end
    end
    
    after do
      disable_js
    end
  end
end
