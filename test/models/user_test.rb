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
end
