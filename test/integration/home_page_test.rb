require 'test_helper'

# See https://github.com/metaskills/minitest-spec-rails#test-styles
class IntegrationTest < ActionDispatch::IntegrationTest

  describe 'the home page' do
    before do
      visit '/'
    end
    it 'displays "home page"' do
      page.must_have_content 'home page'
    end
    it 'display the main menu' do
      page.must_have_selector 'nav#main-menu'
    end
  end
  
  describe 'the main menu' do
    before do
      visit '/'
    end
    it 'has a link to the home page' do
      within 'nav#main-menu' do
        page.must_have_link 'Biodb'
      end
    end
  end

end
