# See http://railscasts.com/episodes/211-validations-in-rails-3?view=asciicast
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value.nil?
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      object.errors[attribute] << (options[:message] || "doesn't look like an email address")
    end
  end
end
