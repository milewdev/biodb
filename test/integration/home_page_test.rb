require 'test_helper'

class IntegrationTest < ActionDispatch::IntegrationTest

  describe 'the home page' do
    describe 'when it is loaded' do
      before do
        visit '/'
      end
      it 'displays "home page"' do
        page.must_have_content 'home page'
      end
    end
  end

end
