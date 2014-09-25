require 'test_helper'

describe User do
  
  describe 'when highlights is valid' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '[{"name":"n","content":"c"}]'})}
    specify { User.find(user.id).highlights.must_equal '[{"name":"n","content":"c"}]' }
  end

  describe 'when highlights is null' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: nil})}
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights is empty' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: ''})}
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights is blank' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '  '})}
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

  describe 'when highlights has blank lines' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '[{"name":"n1","content":"c1"},{"name":"","content":""},{"name":"n3","content":"c3"}]'})}
    specify { User.find(user.id).highlights.must_equal '[{"name":"n1","content":"c1"},{"name":"n3","content":"c3"}]' }
  end
  
  describe 'when all the fields are empty' do
    let(:user) {User.create!({email: 'email@test.com', password: 'Password1234', password_confirmation: 'Password1234', highlights: '[{"name":"","content":""}]'})}
    specify { User.find(user.id).highlights.must_equal '[]' }
  end

end
