require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  
  def sign_in
    sign_out    
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => users(:name1).email
    fill_in 'Password', :with => 'Password1234'
    click_button 'Sign in'
  end
  
  def sign_out
    click_link 'sign out' if page.has_link? 'sign out'
  end
  
  def enable_js
    Capybara.current_driver = :poltergeist
  end
  
  def disable_js
    Capybara.use_default_driver
  end

  describe 'home page' do
    before do
      visit home_path
    end
    it 'displays the main menu' do
      page.must_have_link 'Biodb'
    end
  end

  describe 'when a user is not signed in' do
    before do
      visit home_path
    end
    it 'has a sign up link' do
      page.must_have_link 'sign up'
    end
    it 'has a sign in link' do
      page.must_have_link 'sign in'
    end
  end
  
  describe 'when a user is signed in' do
    before do
      sign_in
    end    
    it 'does not have a sign up link' do
      page.wont_have_link 'sign up'
    end
    it 'does not have a sign in link' do
      page.wont_have_link 'sign in'
    end
    it 'displays the user\'s email address' do
      page.must_have_content users(:name1).email
    end
    after do
      sign_out
    end
  end
  
  describe 'the sign up link' do
    describe 'when it is clicked' do
      before do
        visit home_path
        click_link 'sign up'
      end
      it 'displays the sign up page' do
        current_path.must_equal new_user_path
      end
    end
  end
  
  describe 'the sign in link' do
    describe 'when it is clicked' do
      before do
        visit home_path
        click_link 'sign in'
      end
      it 'displays the sign in page' do
        current_path.must_equal new_session_path
      end
    end
  end
  
  describe 'the highlight list' do
    
    before do
      enable_js
      sign_in
      visit home_path
    end
    
    it 'displays all the highlights of the logged in user' do
      users(:name1).highlights.each do |highlight|
        find("textarea[data-id='#{highlight.id}']").value.must_equal highlight.content
      end
    end
    
    let(:first_id) { highlights(:highlight1_1).id }
    let(:second_id) { highlights(:highlight1_2).id }
    it 'displays the highlights in sort order' do
      page.source.must_match /data-id="#{first_id}".*data-id="#{second_id}"/
    end
    
    describe 'when text is entered at the end of a highlight field' do
      let(:highlight) { highlights(:highlight1_1) }
      let(:highlight_field) { find("textarea[data-id='#{highlight.id}']") }
      before do
        highlight_field.native.send_keys(' new content')
      end
      it 'is appended to the highlight value' do
        highlight_field.value.must_equal highlight.content + ' new content'
      end
    end
    
    describe 'when <return> is pressed at the end of a highlight field' do
      let(:highlight1) { highlights(:highlight1_1) }
      let(:highlight2) { highlights(:highlight1_2) }
      let(:highlight1_field) { find("textarea[data-id='#{highlight1.id}']") }
      before do
        highlight1_field.native.send_key(:Enter)
      end
      it 'inserts a new highlight field after the one in which enter was pressed' do
        page.all('textarea')[0]['data-id'].must_equal "#{highlight1.id}"
        page.all('textarea')[1]['data-id'].must_equal '-1'
        page.all('textarea')[2]['data-id'].must_equal "#{highlight2.id}"
      end
      it 'sets the new highlight field to blank' do
        page.all('textarea')[1].value.must_equal ''
      end
      it 'sets the new highlight field id to -1' do
        page.all('textarea')[1]['data-id'].must_equal '-1'
      end
      it 'puts the cursor at the beginning of the new highlight' do
        # TODO: this only tests that the cursor is in the new highlight field,
        # not that it is at the begining of the field.
        page.evaluate_script("document.activeElement.getAttribute('data-id')").must_equal '-1'
      end
    end
    
    describe 'when <return> is pressed in the middle of a highlight field' do
      let(:highlight1) { highlights(:highlight1_1) }
      let(:highlight2) { highlights(:highlight1_2) }
      let(:highlight1_field) { find("textarea[data-id='#{highlight1.id}']") }
      before do
        highlight1_field.native.send_keys(:Left, :Left, :Left, :Enter)
      end
      it 'removes everything after the cursor location from the highlight field' do
        highlight1_field.value.must_equal highlights(:highlight1_1).content[0..-4]
      end
      it 'adds everything after the cursor location to the newly inserted highlight field' do
        page.all('textarea')[1].value.must_equal highlights(:highlight1_1).content[-3..-1]
      end
    end
    
    describe 'when <delete> is pressed at the beginning of the first highlight field' do
      let(:highlight1) { highlights(:highlight1_1) }
      let(:highlight1_field) { find("textarea[data-id='#{highlight1.id}']") }
      before do
        highlight1_field.native.send_keys(:Home, :Backspace)
      end
      it 'does nothing' do
        highlight1_field.value.must_equal highlight1.content
      end
    end
    
    describe 'when <delete> is pressed at the beginning of the second highlight field' do
      let(:highlight1) { highlights(:highlight1_1) }
      let(:highlight2) { highlights(:highlight1_2) }
      let(:highlight1_field) { find("textarea[data-id='#{highlight1.id}']") }
      let(:highlight2_field) { find("textarea[data-id='#{highlight2.id}']") }
      before do
        highlight2_field.native.send_keys(:Home, :Backspace)
      end
      it 'append the content of the second highlight field to the first one' do
        highlight1_field.value.must_equal highlight1.content + highlight2.content
      end
      it 'deletes the second highlight field' do
        page.wont_have_css "textarea[data-id='#{highlight2.id}']"
      end
      it 'leaves the focus on the first highlight field' do
        page.evaluate_script("document.activeElement.getAttribute('data-id')").must_equal "#{highlight1.id}"
      end
      it 'leaves the caret at the content join point' do
        page.evaluate_script("$(document.activeElement).caret()").must_equal highlight1.content.length
      end
    end
    
    describe 'when <delete> is pressed anywhere other than the beginning of the second highlight field' do
      let(:highlight1) { highlights(:highlight1_1) }
      let(:highlight2) { highlights(:highlight1_2) }
      let(:highlight1_field) { find("textarea[data-id='#{highlight1.id}']") }
      let(:highlight2_field) { find("textarea[data-id='#{highlight2.id}']") }
      before do
        highlight2_field.native.send_keys(:Home, :Right, :Right, :Backspace)
      end
      it 'deletes the character to the left of the caret in the second highlight field' do
        expected_content = highlight2.content
        expected_content[1] = ''
        highlight2_field.value.must_equal expected_content
      end
      it 'does not change the contents of the first highlight field' do
        highlight1_field.value.must_equal highlight1.content
      end
      it 'does not delete the second highlight field' do
        page.must_have_css "textarea[data-id='#{highlight2.id}']"
      end
    end
    
    after do
      sign_out
      disable_js
    end
    
  end

end
