require 'test_helper'

describe User do
  
  describe 'when password is valid' do
    let(:user) {User.create({password: 'ValidPassword1234', password_confirmation: 'ValidPassword1234'})}
    specify { user.errors[:password].must_be_empty }
  end
  
  describe 'when password is missing' do
    let(:user) {User.create({password: nil, password_confirmation: nil})}
    specify { user.errors[:password].must_include "can't be blank" }
  end
  
  describe 'when password is too short' do
    let(:user) {User.create({password: 'aA3456789', password_confirmation: 'aA3456789'})}
    specify { user.errors[:password].must_include 'is too short (minimum is 10 characters)' }
  end
  
  [ 'nouppercase1', 'NOLOWERCASE1', 'NoNumbers' ].each do |bad_password|
    describe "when password is invalid (#{bad_password})" do
      let(:user) {User.create({password: bad_password, password_confirmation: bad_password})}
      specify { user.errors[:password].must_include 'is invalid (it must contain a mixture of numbers and lower and upper case letters)' }
    end
  end
  
  describe 'when password confirmation does not match' do
    let(:user) {User.create({password: 'ValidPassword1234', password_confirmation: 'ValidPassword5678'})}
    specify { user.errors[:password_confirmation].must_include 'doesn\'t match Password' }
  end

end
