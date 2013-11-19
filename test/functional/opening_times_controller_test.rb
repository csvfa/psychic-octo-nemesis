require 'test_helper'

class OpeningTimesControllerTest < ActionController::TestCase
  setup do
    @opening_time = opening_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opening_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opening_time" do
    assert_difference('OpeningTime.count') do
      post :create, :opening_time => @opening_time.attributes
    end

    assert_redirected_to opening_time_path(assigns(:opening_time))
  end

  test "should show opening_time" do
    get :show, :id => @opening_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @opening_time
    assert_response :success
  end

  test "should update opening_time" do
    put :update, :id => @opening_time, :opening_time => @opening_time.attributes
    assert_redirected_to opening_time_path(assigns(:opening_time))
  end

  test "should destroy opening_time" do
    assert_difference('OpeningTime.count', -1) do
      delete :destroy, :id => @opening_time
    end

    assert_redirected_to opening_times_path
  end
end
