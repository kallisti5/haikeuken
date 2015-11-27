require 'test_helper'

class HelpControllerTest < ActionController::TestCase
  test 'should get builders' do
    get :builders
    assert_response :success
  end

  test 'should get recipes' do
    get :recipes
    assert_response :success
  end

  test 'should get repos' do
    get :repos
    assert_response :success
  end

  test 'should get builds' do
    get :builds
    assert_response :success
  end

end
