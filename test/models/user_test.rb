require 'test_helper'

describe User do
  describe 'email' do
    describe 'when it is valid' do
      let(:user) {User.create({email: "name@company.com"})}
      it 'does not have any errors' do
        user.errors[:email].must_be_empty
      end
    end
    
    describe 'when it is missing' do
      let(:user) {User.create({email: nil})}
      it 'has the error "can\'t be blank"' do
        user.errors[:email].must_include "can't be blank"
      end
    end
    
    describe 'when it is empty' do
      let(:user) {User.create({email: ''})}
      it 'has the error "can\'t be blank"' do
        user.errors[:email].must_include "can't be blank"
      end
    end
    
    describe 'when it is blank' do
      let(:user) {User.create({email: ' '})}
      it 'has the error "can\'t be blank"' do
        user.errors[:email].must_include "can't be blank"
      end
    end
    
    describe 'when it already exists' do
      let(:user) do
        User.create({email: 'name@company.com', password: 'ValidPassword1234', password_confirmation: 'ValidPassword1234'})
        User.create({email: 'NAME@company.com'})
      end
      it 'has the error "already in use"' do
        user.errors[:email].must_include 'has already been taken'
      end
    end
    
    [ 'name', '@', 'company.com', 'name@', '@company', '@company.com', 'name@company', 'name@company.c' ].each do |bad_email|
      describe "when it is invalid (#{bad_email})" do
        let(:user) {User.create({email: bad_email})}
        it 'has the error "doesn\'t look like an email address"' do
          user.errors[:email].must_include "doesn't look like an email address"
        end
      end
    end
  end
  
  describe 'password' do
    describe 'when it is valid' do
      let(:user) {User.create({password: 'ValidPassword1234', password_confirmation: 'ValidPassword1234'})}
      it 'does not have any errors' do
        user.errors[:password].must_be_empty
      end
    end
    
    describe 'when it is missing' do
      let(:user) {User.create({password: nil, password_confirmation: nil})}
      it 'has the error "can\'t be blank"' do
        user.errors[:password].must_include "can't be blank"
      end
    end
    
    describe 'when it is too short' do
      let(:user) {User.create({password: 'aA3456789', password_confirmation: 'aA3456789'})}
      it 'has the error "is too short (minimum is 10)"' do
        user.errors[:password].must_include 'is too short (minimum is 10 characters)'
      end
    end
    
    [ 'nouppercase1', 'NOLOWERCASE1', 'NoNumbers' ].each do |bad_password|
      describe "when it is invalid (#{bad_password})" do
        let(:user) {User.create({password: bad_password, password_confirmation: bad_password})}
        it 'has the error "is invalid"' do
          user.errors[:password].must_include 'is invalid (it must contain a mixture of numbers and lower and upper case letters)'
        end
      end
    end
    
    describe 'when the password confirmation does not match' do
      let(:user) {User.create({password: 'ValidPassword1234', password_confirmation: 'ValidPassword5678'})}
      it 'has the error "doesn\'t match password"' do
        user.errors[:password_confirmation].must_include 'doesn\'t match Password'
      end
    end
  end
  
  describe 'highlights' do
    describe 'when it is null' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: nil})}
      it 'is saved as null' do
        User.find(user.id).highlights.must_be_nil
      end
    end
    
    describe 'when it is empty' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: ''})}
      it 'is saved as null' do
        User.find(user.id).highlights.must_be_nil
      end
    end
    
    describe 'when it is blank' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '  '})}
      it 'is saved as null' do
        User.find(user.id).highlights.must_be_nil
      end
    end
    
    describe 'when it is blank lines' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: " \n\n \n"})}
      it 'is saved as null' do
        User.find(user.id).highlights.must_be_nil
      end
    end
    
    describe 'when it has blank lines' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: "one\n\n\ntwo"})}
      it 'removes the blank lines' do
        User.find(user.id).highlights.must_equal "one\ntwo"
      end
    end
    
    describe 'when it has a trailing newline' do
      let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: "one\ntwo\n"})}
      it 'removes the trailing newline' do
        User.find(user.id).highlights.must_equal "one\ntwo"
      end
    end
    
  end
end
