require 'test_helper'

class HighlightsControllerTest < ActionController::TestCase
  setup do
    @user = users(:name1)
    @highlight = highlights(:highlight1_1)
  end

  test "should get index" do
    get :index, user_id: @user
    assert_response :success
    assert_not_nil assigns(:highlights)
  end

  test "should get new" do
    get :new, user_id: @user
    assert_response :success
  end

  test "should create highlight" do
    assert_difference('Highlight.count') do
      post :create, user_id: @highlight.user_id, highlight: { content: @highlight.content }
    end

    assert_redirected_to user_highlight_path(@user, assigns(:highlight))
  end

  test "should show highlight" do
    get :show, user_id: @user, id: @highlight
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user, id: @highlight
    assert_response :success
  end

  test "should update highlight" do
    patch :update, user_id: @highlight.user_id, id: @highlight, highlight: { content: @highlight.content }
    assert_redirected_to user_highlight_path(@user, assigns(:highlight))
  end

  test "should destroy highlight" do
    assert_difference('Highlight.count', -1) do
      delete :destroy, user_id: @user, id: @highlight
    end

    assert_redirected_to user_highlights_path(@user)
  end
end
