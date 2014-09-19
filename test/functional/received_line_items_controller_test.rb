require 'test_helper'

class ReceivedLineItemsControllerTest < ActionController::TestCase
  setup do
    @received_line_item = received_line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:received_line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create received_line_item" do
    assert_difference('ReceivedLineItem.count') do
      post :create, received_line_item: @received_line_item.attributes
    end

    assert_redirected_to received_line_item_path(assigns(:received_line_item))
  end

  test "should show received_line_item" do
    get :show, id: @received_line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @received_line_item
    assert_response :success
  end

  test "should update received_line_item" do
    put :update, id: @received_line_item, received_line_item: @received_line_item.attributes
    assert_redirected_to received_line_item_path(assigns(:received_line_item))
  end

  test "should destroy received_line_item" do
    assert_difference('ReceivedLineItem.count', -1) do
      delete :destroy, id: @received_line_item
    end

    assert_redirected_to received_line_items_path
  end
end
