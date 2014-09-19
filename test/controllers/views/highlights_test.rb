require 'test_helper'

class FieldIntegrationTest < ActionDispatch::IntegrationTest
  
  describe 'highlights in edit mode' do
    let(:user) { User.create!( email: 'highlights@test.com', password: 'Password1234', highlights: "one\ntwo" ) }
    before do
      sign_in user
      use_edit_mode
    end
    specify { user_highlights.html.must_equal '<li>one</li><li>two</li>' }
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
  
  # saving highlights (check both the screen fields and the database):
  #   happy path
  #   empty content is saved as nil
  #   blank content is saved as nil
  #   interspersed blank lines removed
  #   trailing blank lines removed
  # these edits need to be added to the client and the model
  
end
