require 'test_helper'

describe User do

  # TODO: this is duplicated at the top of jobs_test, but 
  # not convinced that is a bad thing; duplicating it allows
  # you to see exactly what the test is about.  However, may
  # consider renaming this to 'create_generic_user' which 
  # may be enough to make it understandable.
  def create_user!(attributes)
    User.create!( {
      email: 'email@test.com', 
      password: 'Password1234', 
      password_confirmation: 'Password1234', 
      highlights: '[{"name":"languanges", "content":"C, C++, Ruby"}]', 
      jobs: '[{"company":"company", "date_range":"2014", "role":"developer", "tasks":["wrote tests","wrote code","deployed app"]}]'
    }.merge(attributes) )
  end
  
  describe 'when highlights is valid' do
    let(:highlights) { '[{"name":"n","content":"c"}]' }
    let(:user) { create_user!({ highlights: highlights }) }
    specify { User.find(user.id).highlights.must_equal '[{"name":"n","content":"c"}]' }
  end

  describe 'when highlights is null' do
    let(:user) { create_user!({ highlights: nil }) }
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights is empty' do
    let(:user) { create_user!({ highlights: '' }) }
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights is blank' do
    let(:user) { create_user!({ highlights: '  ' }) }
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights has blank lines' do
    let(:user) { create_user!({ highlights: '[{"name":"n1","content":"c1"},{"name":"","content":""},{"name":"n3","content":"c3"}]' }) }
    specify { User.find(user.id).highlights.must_equal '[{"name":"n1","content":"c1"},{"name":"n3","content":"c3"}]' }
  end
  
  describe 'when all the fields are empty' do
    let(:user) { create_user!({ highlights: '[{"name":"","content":""}]' }) }
    specify { User.find(user.id).highlights.must_equal '[]' }
  end
  
  # TODO
  describe 'when attributes have leading and/or trailing whitespace' do
  end

end
