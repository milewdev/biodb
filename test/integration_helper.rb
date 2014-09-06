module IntegrationHelper

  #
  # element selectors
  #

  EditModeCheckboxSelector = '#edit-mode-checkbox'
  TitleSelector = '.user-title'

  
  #
  # elements on the page
  #

  def edit_mode_checkbox
    find(EditModeCheckboxSelector)
  end
   
  def title
    find(TitleSelector)
  end
  
  
  #
  # expectations
  #
  
  # See http://sideshowcoder.com/post/41185074450/checking-for-the-css-class-of-the-found-element-in
  def must_have_class(element, css_class)    
    element[:class].must_include css_class
  end
  
  def must_be_in_view_mode
    edit_mode_checkbox.checked?.must_equal false
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
  
  def delete_text_of(element)
    # WARNING: may not work with textareas or text inputs
    # Yep, that's end and backspace and backspace and backspace and ...
    element.native.send_keys :End, *( Array.new( element.text.length, :Backspace ) )
  end

end
