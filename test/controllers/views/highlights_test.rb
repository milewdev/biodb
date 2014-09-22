require 'test_helper'

class FieldIntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one\ntwo\nthree" ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li>one</li><li>two</li><li>three</li>' }
  end
  
  describe 'nil highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: nil ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li></li>' }
  end
  
  describe 'empty highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '' ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li></li>' }
  end
  
  describe 'blank highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: '  ' ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li></li>' }
  end
  
  describe 'blank lines in highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one\n\ntwo" ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li>one</li><li>two</li>' }
  end
  
  describe 'trailing returns in highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one\n" ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li>one</li>' }
  end

  describe 'saving changes to highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one" ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, :Enter, 'two'
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_equal "one\ntwo" }
  end
  
  describe 'saving empty highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: " " ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, :Backspace
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'saving blank highlights' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: " " ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, ' '
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'saving highlights with embedded blank lines' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one" ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, :Enter, :Enter, 'two'
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_equal "one\ntwo" }
  end
  
  describe 'saving highlights with trailing blank lines' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one" ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, :Enter, :Enter
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_equal "one" }
  end
  
  describe 'saving highlights that are nothing but blank lines' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: nil ) }
    before do
      sign_in user
      use_edit_mode
      user_highlights.native.send_keys :End, ' ', :Enter, :Enter, ' ', :Enter
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
end
