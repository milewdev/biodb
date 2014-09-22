require 'test_helper'

describe User do
  
  describe 'when highlights is valid' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: 'one\ntwo\nthree'})}
    specify { User.find(user.id).highlights.must_equal 'one\ntwo\nthree' }
  end

  describe 'when highlights is null' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: nil})}
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'when highlights is empty' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: ''})}
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'when highlights is blank' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '  '})}
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'when highlights is blank lines' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: " \n\n \n"})}
    specify { User.find(user.id).highlights.must_be_nil }
  end
  
  describe 'when highlights has blank lines' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: "one\n\n\ntwo"})}
    specify { User.find(user.id).highlights.must_equal "one\ntwo" }
  end
  
  describe 'when highlights has a trailing newline' do
    let(:user) {User.create({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: "one\ntwo\n"})}
    specify { User.find(user.id).highlights.must_equal "one\ntwo" }
  end  

end
