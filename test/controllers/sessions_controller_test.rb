require 'test_helper'

describe SessionsController do
  describe 'new' do
    before do
      get :new
    end
    it 'returns the sign in page' do
      assert_template :new
    end
  end
  
  describe 'create' do
    describe 'when it is called with a known user' do
      before do
        post :create, email: users(:generic_user).email, password: 'Password1234'
      end
      it 'saves the user\'s id in the session' do
        session[:user_id].must_equal users(:generic_user).id
      end
      it 'redirects to the home page' do      # TODO: it should redirect to the page the user was originally on
        assert_redirected_to home_path
      end
    end
  
    describe 'when it is called with an unknown email' do
      before do
        post :create, email: 'unknown', password: 'Password1234'
      end
      it 'returns to the sign in page' do
        assert_template :new
      end
      it 'displays an invalid sign in message' do
        flash[:alert].must_equal 'Invalid email and/or password'
      end
    end
    
    describe 'when it is called with the wrong password' do
      before do
        post :create, email: users(:generic_user).email, password: 'WrongPassword'
      end
      it 'returns to the sign in page' do
        assert_template :new
      end
      it 'displays an invalid sign in message' do
        flash[:alert].must_equal 'Invalid email and/or password'
      end
    end
  end
  
  describe 'destroy' do
    describe 'when a user is signed in' do
      before do
        session[:user_id] = 12345
        delete :destroy
      end
      it 'clears the user\'s id from the session' do
        session[:user_id].must_be_nil
      end
      it 'redirects to the home page' do
        assert_redirected_to home_path
      end
    end
    
    describe 'when a user is not signed in' do
      before do
        session[:user_id] = nil
        delete :destroy
      end
      it 'leaves the user id as nil in the session' do
        session[:user_id].must_be_nil
      end
      it 'redirects to the home page' do
        assert_redirected_to home_path
      end
    end
  end
end
