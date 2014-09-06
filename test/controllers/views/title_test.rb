require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  include IntegrationHelper
  
  describe 'a user\'s title' do
    before do
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
          wont_be_visible(title)
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
      before do
        sign_in users(:with_title)
        use_edit_mode
        title.native.send_keys :Home, 'abc'
      end
      
      it 'changes the title' do
        title.text.must_equal "abc#{users(:with_title).title}"
      end
    end
    
    describe 'when the user deletes the title and then switches to view mode' do
      before do
        sign_in users(:with_title)
        use_edit_mode
        delete_inner_text title
        use_view_mode
      end
      it 'hides the title' do
        wont_be_visible(title)
      end
    end
    
    describe 'when title is visible' do
      before do
        sign_in users(:with_title)
      end
      it 'has the class visible' do
        must_have_class(title, 'visible')
      end
      it 'does not have the class hidden' do
        wont_have_class(title, 'hidden')
      end
    end
    
    describe 'when title is not visible' do
      before do
        sign_in users(:no_title)
      end
      it 'has the class hidden' do
        must_have_class(title, 'hidden')
      end
      it 'does not have the class visible' do
        wont_have_class(title, 'visible')
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
    
    after do
      disable_js
    end
  end
end
