require 'test_helper'

describe User do

  @MISSING_VALUES = [ nil, '', ' ' * 3 ]

  describe 'when highlights is valid' do
    let(:user) { User.create!(valid_highlights) }
    it 'is saved' do
      User.find(user.id).highlights.must_equal valid_highlights[:highlights]
    end
  end

  @MISSING_VALUES.each do |missing_value|
    describe "when highlights is missing: #{missing_value}" do
      let(:user) { User.create!(missing_highlights(missing_value)) }
      it 'is saved as an empty array' do
        User.find(user.id).highlights.must_equal '[]'
      end
    end
  end
  
  describe 'when a highlight is empty' do
    let(:user) { User.create!(empty_highlight) }
    it 'is not saved' do
      User.find(user.id).highlights.must_equal '[]'
    end
  end

  describe 'when attributes have leading and/or trailing whitespace' do
    let(:user) { User.create!(whitespaced_highlight_attributes)}
    it 'trims the spaces before saving' do
      User.find(user.id).highlights.must_equal stripped_highlight_attributes[:highlights]
    end
  end

  def valid_highlights
    {
      email: 'email@test.com',
      password: 'Password1234',
      password_confirmation: 'Password1234',
      name: 'name',
      title: 'title',
      highlights: JSON.generate( [{name: "languanges", content: "C, C++, Ruby"}] ), 
      jobs: JSON.generate( [{company: "company", date_range: "2014", role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    }
  end

  def missing_highlights(missing_value)
    valid_highlights.merge({
      highlights: missing_value
    })
  end
  
  def empty_highlight
    valid_highlights.merge({
      highlights: JSON.generate( [{name: "", content: ""}] )
    })
  end

  def whitespaced_highlight_attributes
    valid_highlights.merge({
      highlights: JSON.generate( [{name: " languanges ", content: " C, C++, Ruby "}] ), 
    })
  end

  def stripped_highlight_attributes
    valid_highlights.merge({
      highlights: JSON.generate( [{name: "languanges", content: "C, C++, Ruby"}] ), 
    })
  end
  
end
