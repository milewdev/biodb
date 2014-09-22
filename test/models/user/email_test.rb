require 'test_helper'

describe User do
  describe 'when email is valid' do
    let(:user) {User.create({email: "name@company.com"})}
    specify { user.errors[:email].must_be_empty }
  end
  
  describe 'when email is missing' do
    let(:user) {User.create({email: nil})}
    specify { user.errors[:email].must_include "can't be blank" }
  end
  
  describe 'when email is empty' do
    let(:user) {User.create({email: ''})}
    specify { user.errors[:email].must_include "can't be blank" }
  end
  
  describe 'when email is blank' do
    let(:user) {User.create({email: ' '})}
    specify { user.errors[:email].must_include "can't be blank" }
  end
  
  describe 'when email already exists' do
    let(:user) do
      User.create({email: 'name@company.com', password: 'ValidPassword1234', password_confirmation: 'ValidPassword1234'})
      User.create({email: 'NAME@company.com'})
    end
    specify { user.errors[:email].must_include 'has already been taken' }
  end
  
  [ 'name', '@', 'company.com', 'name@', '@company', '@company.com', 'name@company', 'name@company.c' ].each do |bad_email|
    describe "when email is invalid (#{bad_email})" do
      let(:user) {User.create({email: bad_email})}
      specify { user.errors[:email].must_include "doesn't look like an email address" }
    end
  end
end
