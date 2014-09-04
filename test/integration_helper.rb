module IntegrationHelper

  def sign_in
    sign_out    
    visit home_path
    click_link 'sign in'
    fill_in 'Email', :with => users(:one).email
    fill_in 'Password', :with => 'Password1234'
    click_button 'Sign in'
  end
  
  def sign_out
    click_link 'sign out' if page.has_link? 'sign out'
  end

end
