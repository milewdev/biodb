require 'test_helper'

describe UsersController do
  describe 'create' do
    before do
      post :create, user: { email: 'name3@company.com', password: 'Password1234', password_confirmation: 'Password1234' }
    end
    it 'signs in the created user' do
      session[:user_id].must_equal assigns(:user).id
    end
  end
end

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:generic)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: 'name@company.com', password: 'Password1234', password_confirmation: 'Password1234' }
    end

    assert_redirected_to home_path
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email, password: 'Password1234', password_confirmation: 'Password1234' }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
