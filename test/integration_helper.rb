module IntegrationHelper

  #
  # element selectors
  #

  # TODO: can we eliminate these?  Yes, if they are only used in one place, ie the 
  # element helpers below.  Note that TitleSelector is used in a test to test for
  # the presence of the title element, not for its visibility; is there another 
  # way of doing this?
  HomeLinkSelector = '#home-link'
  EditModeCheckboxSelector = '#edit-mode-checkbox'
  SaveButtonSelector = '#save-button'
  UserNameSelector = '#user-name'
  TitleSelector = '#user-title'   # TODO: rename to UserTitleSelector
  UserEmailSelector = '#user-email'
  
  
  #
  # general helpers
  #
  
  def stub_onbeforeunload
    debug 'stub_onbeforeunload: stubbing window.onbeforeunload in the browser'
    page.execute_script 'window.onbeforeunload = function () {}'
  end
  
  def capture_onbeforeunload(&block)
    page.execute_script <<-'EOF'
      localStorage.removeItem("onbeforeunload_result");
      var onbeforeunload_original = window.onbeforeunload;
      window.onbeforeunload = function () { localStorage.onbeforeunload_result = onbeforeunload_original(); }
    EOF
    yield
    page.evaluate_script('localStorage.onbeforeunload_result')
  ensure
    page.execute_script <<-'EOF'
      localStorage.removeItem("onbeforeunload_result");
    EOF
  end
  
  # See http://www.youtube.com/watch?v=pMZskZW-XdI
  # See https://github.com/teampoltergeist/poltergeist/tree/master/lib/capybara/poltergeist/network_traffic
  def dump_network_traffic
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        $stderr.puts "\nRequest:", request.url, request.method, request.headers, "\n"
        $stderr.puts "Response:", response.status, response.status_text, response.headers, "\n"
      end
    end
  end

  
  #
  # elements on the page
  #
  
  def home_link
    find(HomeLinkSelector)
  end

  def edit_mode_checkbox
    find(EditModeCheckboxSelector)
  end
  
  def save_button
    find(SaveButtonSelector)
  end
  
  def user_name
    find(UserNameSelector, visible: false)
  end
   
  # TODO: rename to user_title
  def title
    # 'visible: false' finds visible and hidden elements on the page and we want to be able
    # to find the title whether it is visible or not.
    # See: https://github.com/jnicklas/capybara/blob/master/lib/capybara/node/finders.rb#L135
    find(TitleSelector, visible: false)
  end
  
  def user_email
    find(UserEmailSelector, visible: false)
  end
  
  
  #
  # expectations
  #
  
  # See http://sideshowcoder.com/post/41185074450/checking-for-the-css-class-of-the-found-element-in
  def must_have_class(element, css_class)    
    element[:class].wont_be_nil('element is missing the class attribute (javascript required, e.g. poltergeist?)')
    element[:class].must_include css_class
  end
  
  def wont_have_class(element, css_class)
    element[:class].nil? or element[:class].wont_include css_class
  end
  
  def must_be_visible(element)
    must_have_class(element, 'visible')
    wont_have_class(element, 'hidden')
  end
  
  def wont_be_visible(element)
    must_have_class(element, 'hidden')
    wont_have_class(element, 'visible')
  end
  
  def must_be_editable(element)
    must_have_class(element, 'edit-mode')
    wont_have_class(element, 'view-mode')
  end
  
  def wont_be_editable(element)
    must_have_class(element, 'view-mode')
    wont_have_class(element, 'edit-mode')
  end


  #
  # actions
  #

  def sign_in(user_fixture)
    user = users(user_fixture)
    sign_out    
    debug "sign_in: signing in as #{user.as_json(only: [:email, :title])}"
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'Password1234'
    click_button 'Sign in'
  end

  def sign_out
    if page.has_link? 'sign out'
      debug 'sign_out: signing out'
      click_link 'sign out'
    else
      debug 'sign_out: ignoring; not currently signed in'
    end
  end

  def use_view_mode
    debug 'use_view_mode: switching to view mode'
    edit_mode_checkbox.set(false)
  end

  def use_edit_mode
    debug 'use_edit_mode: switching to edit mode'
    edit_mode_checkbox.set(true)
  end
  
  def delete_inner_text(element)
    # Yep, that's end, and backspace, and backspace, and backspace, and ...
    element.native.send_keys :End, *( Array.new( element.text.length, :Backspace ) )
  end

end
