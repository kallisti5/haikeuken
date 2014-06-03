require 'test_helper'

class LintsControllerTest < ActionController::TestCase
  setup do
    @lint = lints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lint" do
    assert_difference('Lint.count') do
      post :create, lint: { clean: @lint.clean, result: @lint.result }
    end

    assert_redirected_to lint_path(assigns(:lint))
  end

  test "should show lint" do
    get :show, id: @lint
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lint
    assert_response :success
  end

  test "should update lint" do
    patch :update, id: @lint, lint: { clean: @lint.clean, result: @lint.result }
    assert_redirected_to lint_path(assigns(:lint))
  end

  test "should destroy lint" do
    assert_difference('Lint.count', -1) do
      delete :destroy, id: @lint
    end

    assert_redirected_to lints_path
  end
end
