require 'test_helper'

describe User do
  
  describe 'when name is valid' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', name: 'First Last' ) }
    specify { User.find(user.id).name.must_equal user.name }
  end

  describe 'when name is null' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', name: nil ) }
    specify { User.find(user.id).name.must_equal nil }
  end

  describe 'when name is empty' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', name: '' ) }
    specify { User.find(user.id).name.must_equal nil }
  end

  describe 'when name is blank' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', name: '   ' ) }
    specify { User.find(user.id).name.must_equal nil }
  end

  describe 'when name has leading and trailing spaces' do
    let(:user) { User.create!( email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', name: ' First Last ' ) }
    specify { User.find(user.id).name.must_equal user.name.strip() }
  end

end
