require 'test_helper'

class EmailIntergationTest < ActionDispatch::IntegrationTest
  
  describe 'a user\'s email address' do
    describe 'when a user is signed in' do
      before do
        sign_in users(:generic)
      end
      it 'is displayed' do
        page.must_have_css UserEmailSelector
      end
    end
    
    describe 'when in edit mode' do
      before do
        sign_in users(:generic)
        use_edit_mode
      end
      it 'is not editable' do
        wont_be_editable(user_email)
      end
    end
  end

end
