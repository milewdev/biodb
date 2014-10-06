require 'test_helper'

class FieldIntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'entering edit mode with existing highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
    end
    it 'will display a blank last row in addition to the existing highlights' do
      user_highlights.cell(1,1).text.must_equal 'n'
      user_highlights.cell(1,2).text.must_equal 'c'
      user_highlights.cell(2,1).text.must_equal ''
      user_highlights.cell(2,2).text.must_equal ''
    end
  end
  
  describe 'entering edit mode with no highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[]' ) }
    before do
      sign_in user
      use_edit_mode
    end
    it 'will display a blank row' do
      user_highlights.cell(1,1).text.must_equal ''
      user_highlights.cell(1,2).text.must_equal ''
    end
  end
  
  describe 'entering edit mode when the last row is blank' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode   # adds a blank row
      use_view_mode 
      use_edit_mode   # must not add another blank row
    end
    it 'will not add another blank last row' do
      all('table#user-highlights tr', visible: true).length.must_equal 2
    end
  end
  
  describe 'a blank line in view mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do 
      sign_in user
      use_edit_mode   # adds a blank row
      use_view_mode
    end
    it 'is hidden' do
      all('table#user-highlights tr', visible: true).length.must_equal 1
    end
  end
  
  describe 'entering text in the blank last row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(2,1).native.send_keys 'a'
    end
    it 'adds a new blank last row' do
      user_highlights.cell(3,1).text.must_equal ''
      user_highlights.cell(3,2).text.must_equal ''
    end
  end
  
  describe 'deleting all text from the second last row thereby making it a blank row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":""}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,1).native.send_keys :End, :Backspace
    end
    it 'removes the last blank row' do
      all('table#user-highlights tr', visible: true).length.must_equal 1
    end
  end
  
  describe 'pressing Enter when on the second last highlight row' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(1,2).native.send_keys :Enter
    end
    it 'does not add another blank last highlight row' do
      all('table#user-highlights tr', visible: true).length.must_equal 2
    end
    it 'moves the focus to the first field of the last row'
  end
  
  describe 'pressing Enter on the last highlight row when it is blank' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n","content":"c"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(2,2).native.send_keys :Enter
    end
    it 'does not add another blank last highlight row' do
      all('table#user-highlights tr', visible: true).length.must_equal 2
    end
    it 'does not move the focus'
  end
  
  describe 'pressing Enter on a line when there is a blank line after it' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '[{"name":"n"}, {"name":"n"}, {"name":"n"}]' ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.cell(2,1).native.send_keys :End, :Backspace   # make the second line blank
      user_highlights.cell(1,2).native.send_keys :Enter             # press Enter on the first line
    end
    it 'does not add another blank last highlight row' do
      all('table#user-highlights tr', visible: true).length.must_equal 4
    end
    it 'does not move the focus'
  end

end
