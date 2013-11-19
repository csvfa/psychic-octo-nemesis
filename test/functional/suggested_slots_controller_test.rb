require 'test_helper'

class SuggestedSlotsControllerTest < ActionController::TestCase
  setup do
    @suggested_slot = suggested_slots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suggested_slots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create suggested_slot" do
    assert_difference('SuggestedSlot.count') do
      post :create, :suggested_slot => @suggested_slot.attributes
    end

    assert_redirected_to suggested_slot_path(assigns(:suggested_slot))
  end

  test "should show suggested_slot" do
    get :show, :id => @suggested_slot
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @suggested_slot
    assert_response :success
  end

  test "should update suggested_slot" do
    put :update, :id => @suggested_slot, :suggested_slot => @suggested_slot.attributes
    assert_redirected_to suggested_slot_path(assigns(:suggested_slot))
  end

  test "should destroy suggested_slot" do
    assert_difference('SuggestedSlot.count', -1) do
      delete :destroy, :id => @suggested_slot
    end

    assert_redirected_to suggested_slots_path
  end
end
