class PasswordFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value and value.length < 10
      object.errors[attribute] << (options[:message] || 'is too short (minimum is 10 characters)')
    end
    unless ( value =~ /[a-z]/ and value =~ /[A-Z]/ and value =~ /[0-9]/ )
      object.errors[attribute] << (options[:message] || 'is invalid (it must contain a mixture of numbers and lower and upper case letters)')
    end
  end
end
