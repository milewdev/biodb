require 'test_helper'

describe User do
  
  describe 'when title is valid' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', title: 'Title' ) }
    specify { User.find(user.id).title.must_equal user.title }
  end

  describe 'when title is null' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', title: nil ) }
    specify { User.find(user.id).title.must_equal nil }
  end

  describe 'when title is empty' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', title: '' ) }
    specify { User.find(user.id).title.must_equal nil }
  end

  describe 'when title is blank' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', title: '   ' ) }
    specify { User.find(user.id).title.must_equal nil }
  end

  describe 'when title has leading and trailing spaces' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', title: ' Title ' ) }
    specify { User.find(user.id).title.must_equal user.title.strip() }
  end

end
