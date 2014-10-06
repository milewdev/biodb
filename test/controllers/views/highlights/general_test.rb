require 'test_helper'

class FieldIntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'displaying highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n1","content":"c1"},{"name":"n2","content":"c2"}]' ) }
    before do
      sign_in user
      use_view_mode
    end
    it 'will be visible' do
      user_highlights.must_be_visible
    end
    it 'will display the field values' do
      user_highlights.cell(1,1).text.must_equal 'n1'
      user_highlights.cell(1,2).text.must_equal 'c1'
      user_highlights.cell(2,1).text.must_equal 'n2'
      user_highlights.cell(2,2).text.must_equal 'c2'
    end
  end
  
  describe 'an empty highlight in view mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[]' ) }
    before do
      sign_in user
      use_view_mode
    end
    it 'will be hidden' do
      user_highlights.wont_be_visible
    end
  end
  
  describe 'an empty highlight in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[]' ) }
    before do
      sign_in user
      use_edit_mode
    end
    it 'will be visible' do
      user_highlights.must_be_visible
    end
    it 'will have empty fields' do
      user_highlights.cell(1,1).text.must_equal '' 
      user_highlights.cell(1,2).text.must_equal '' 
    end
  end
  
  describe 'an empty highlight in view mode after editing' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :End, :Backspace
      user_highlights.cell(1,2).native.send_keys :End, :Backspace
      use_view_mode
    end
    it 'will be hidden' do
      user_highlights.wont_be_visible
    end
  end
  
  describe 'a change to an existing row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys '1'
    end
    it 'enables the save button' do
      save_button.must_be_enabled
    end
  end
  
  describe 'a change to an existing row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys :End, '1'
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    it 'is saved to the database' do
      User.find(user.id).highlights.must_equal '[{"name":"n","content":"c1"}]'
    end
  end
  
  describe 'a change to a new row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys :Enter
      user_highlights.cell(2,1).native.send_keys 'n2'
    end
    it 'enables the save button' do
      save_button.must_be_enabled
    end
  end
  
  describe 'a new row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys :Enter
      user_highlights.cell(2,1).native.send_keys 'n2'
      user_highlights.cell(2,2).native.send_keys 'c2'
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    it 'is saved to the database' do
      User.find(user.id).highlights.must_equal '[{"name":"n","content":"c"},{"name":"n2","content":"c2"}]'
    end
  end
  
  describe 'a new empty row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :End, 'X', :Enter    # change (i.e. the 'X') enables save, Enter creates empty row
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    it 'is not saved to the database' do
      User.find(user.id).highlights.must_equal '[{"name":"nX","content":"c"}]'
    end
  end
  
  describe 'emptying an existing row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :End, :Backspace
      user_highlights.cell(1,2).native.send_keys :End, :Backspace
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    it 'deletes the row from the database when saved' do
      User.find(user.id).highlights.must_equal '[]'
    end
  end
  
  describe 'pressing Enter in a non-empty name field in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :Enter
    end
    it 'adds a blank row above the current one' do
      user_highlights.cell(1,1).text.must_equal '' 
      user_highlights.cell(1,2).text.must_equal '' 
      user_highlights.cell(2,1).text.must_equal 'n' 
      user_highlights.cell(2,2).text.must_equal 'c' 
    end
    it 'does not enable the save button' do
      save_button.wont_be_enabled
    end
    it 'moves the cursor to the name field of the new row'
  end
  
  describe 'pressing Enter in an empty name field in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :Enter   # insert a new blank row above the current one
      user_highlights.cell(1,1).native.send_keys :Enter   # should not insert a row
    end
    it 'does not add a blank row above the current one' do
      all('table#user-highlights tr', visible: true).length.must_equal 3    # original row + blank last row + new row above
    end
    it 'does not move the cursor to another field'
  end
  
  describe 'pressing Enter in a non-empty content field in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys :Enter
    end
    it 'adds a blank row below the current one' do
      user_highlights.cell(1,1).text.must_equal 'n' 
      user_highlights.cell(1,2).text.must_equal 'c' 
      user_highlights.cell(2,1).text.must_equal '' 
      user_highlights.cell(2,2).text.must_equal '' 
    end
    it 'does not enable the save button' do
      save_button.wont_be_enabled
    end
    it 'moves the cursor to the name field of the new row'
  end
  
  describe 'pressing Enter in an empty content field in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :Enter   # insert a new blank row above the current one
      user_highlights.cell(2,1).native.send_keys :Enter   # should not insert a row (TODO: make the 2 stand out more, compared with test above)
    end
    it 'does not add a blank row above the current one' do
      all('table#user-highlights tr', visible: true).length.must_equal 3    # original row + blank last row + new row above
    end
    it 'does not move the cursor to another field'
  end

end
