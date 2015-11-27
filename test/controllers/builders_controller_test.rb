require 'test_helper'

class BuildersControllerTest < ActionController::TestCase
  setup do
    @builder = builders(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:builders)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create builder' do
    assert_difference('Builder.count') do
      post :create, builder: { architecture_id: @builder.architecture_id, hostname: @builder.hostname, lastheard: @builder.lastheard, location: @builder.location, owner: @builder.owner, token: @builder.token }
    end

    assert_redirected_to builder_path(assigns(:builder))
  end

  test 'should show builder' do
    get :show, id: @builder
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @builder
    assert_response :success
  end

  test 'should update builder' do
    patch :update, id: @builder, builder: { architecture_id: @builder.architecture_id, hostname: @builder.hostname, lastheard: @builder.lastheard, location: @builder.location, owner: @builder.owner, token: @builder.token }
    assert_redirected_to builder_path(assigns(:builder))
  end

  test 'should destroy builder' do
    assert_difference('Builder.count', -1) do
      delete :destroy, id: @builder
    end

    assert_redirected_to builders_path
  end
end
