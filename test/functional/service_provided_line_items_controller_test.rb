require 'test_helper'

class ServiceProvidedLineItemsControllerTest < ActionController::TestCase
  setup do
    @service_provided_line_item = service_provided_line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_provided_line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service_provided_line_item" do
    assert_difference('ServiceProvidedLineItem.count') do
      post :create, service_provided_line_item: @service_provided_line_item.attributes
    end

    assert_redirected_to service_provided_line_item_path(assigns(:service_provided_line_item))
  end

  test "should show service_provided_line_item" do
    get :show, id: @service_provided_line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_provided_line_item
    assert_response :success
  end

  test "should update service_provided_line_item" do
    put :update, id: @service_provided_line_item, service_provided_line_item: @service_provided_line_item.attributes
    assert_redirected_to service_provided_line_item_path(assigns(:service_provided_line_item))
  end

  test "should destroy service_provided_line_item" do
    assert_difference('ServiceProvidedLineItem.count', -1) do
      delete :destroy, id: @service_provided_line_item
    end

    assert_redirected_to service_provided_line_items_path
  end
end
