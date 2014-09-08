module IntegrationHelper

  #
  # element selectors
  #

  HomeLinkSelector = '#home-link'
  EditModeCheckboxSelector = '#edit-mode-checkbox'
  TitleSelector = '#user-title'
  
  
  #
  # general helpers
  #
  
  def enable_js
    Capybara.current_driver = :poltergeist
  end
  
  def disable_js
    Capybara.use_default_driver
  end
  
  def stub_onbeforeunload
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

  
  #
  # elements on the page
  #
  
  def home_link
    find(HomeLinkSelector)
  end

  def edit_mode_checkbox
    find(EditModeCheckboxSelector)
  end
   
  def title
    # 'visible: false' finds visible and hidden elements on the page and we want to be able
    # to find the title whether it is visible or not.
    # See: https://github.com/jnicklas/capybara/blob/master/lib/capybara/node/finders.rb#L135
    find(TitleSelector, visible: false)
  end
  
  
  #
  # expectations
  #
  
  # See http://sideshowcoder.com/post/41185074450/checking-for-the-css-class-of-the-found-element-in
  def must_have_class(element, css_class)    
    element[:class].must_include css_class
  end
  
  def wont_have_class(element, css_class)
    element[:class].wont_include css_class
  end
  
  def must_be_visible(element)
    must_have_class(element, 'visible')
  end
  
  def wont_be_visible(element)
    must_have_class(element, 'hidden')
  end


  #
  # actions
  #

  def sign_in(user = users(:one))
    sign_out    
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'Password1234'
    click_button 'Sign in'
  end

  def sign_out
    click_link 'sign out' if page.has_link? 'sign out'
  end

  def use_view_mode
    edit_mode_checkbox.set(false)
  end

  def use_edit_mode
    edit_mode_checkbox.set(true)
  end
  
  def delete_inner_text(element)
    # Yep, that's end, and backspace, and backspace, and backspace, and ...
    element.native.send_keys :End, *( Array.new( element.text.length, :Backspace ) )
  end

end
