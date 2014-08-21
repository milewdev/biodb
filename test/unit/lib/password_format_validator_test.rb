require 'test_helper'

describe PasswordFormatValidator do
  describe 'when the password is valid' do
    let(:errors) do
      errors = { password: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = PasswordFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :password, 'ValidPassword1234')
      errors
    end
    it 'does not add any errors' do
      errors[:password].must_be_empty
    end
  end
  
  [ 'nouppercase1', 'NOLOWERCASE1', 'NoNumbers' ].each do |bad_password|
    let(:errors) do
      errors = { password: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = PasswordFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :password, bad_password)
      errors
    end
    describe "when the password is invalid (#{bad_password})" do
      it 'adds an "invalid password" error' do
        errors[:password].must_include 'is invalid (it must contain a mixture of numbers and lower and upper case letters)'
      end
    end
  end
  
  describe 'when the password is too short' do
    let(:errors) do
      errors = { password: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = PasswordFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :password, 'Short1')
      errors
    end
    it 'adds a "too short" error' do
      errors[:password].must_include 'is too short (minimum is 10 characters)'
    end
  end
  
  describe 'when the password value is nil' do
    let(:errors) do
      errors = { password: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = PasswordFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :password, nil)
      errors
    end
    it 'does not add any errors' do
      errors[:password].must_be_empty
    end
  end
  
  describe 'when the password value is empty' do
    let(:errors) do
      errors = { password: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = PasswordFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :password, '')
      errors
    end
    it 'does not add any errors' do
      errors[:password].must_be_empty
    end
  end
end
