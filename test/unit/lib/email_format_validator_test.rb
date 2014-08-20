require 'test_helper'

describe EmailFormatValidator do
  describe 'when the email format is valid' do
    let(:errors) do
      errors = { email: [] }
      object = mock()
      object.stubs(:errors).returns(errors)
      validator = EmailFormatValidator.new({attributes: 'anything'})
      validator.validate_each(object, :email, 'name@company.com')
      errors
    end
    it 'does not add any errors' do
      errors[:email].must_be_empty
    end
  end
  
  [ 'name', '@', 'company.com', 'name@', '@company', '@company.com', 'name@company', 'name@company.c' ].each do |bad_email|
    describe "when the email format is invalid (#{bad_email})" do
      let(:errors) do
        errors = { email: [] }
        object = mock()
        object.stubs(:errors).returns(errors)
        validator = EmailFormatValidator.new({attributes: 'anything'})
        validator.validate_each(object, :email, bad_email)
        errors
      end
      it 'adds an "invalid format" error' do
        errors[:email].must_include "doesn't look like an email address"
      end
    end
  end
end
