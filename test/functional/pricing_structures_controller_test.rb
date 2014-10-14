require 'test_helper'

class PricingStructuresControllerTest < ActionController::TestCase
  setup do
    @pricing_structure = pricing_structures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pricing_structures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pricing_structure" do
    assert_difference('PricingStructure.count') do
      post :create, pricing_structure: @pricing_structure.attributes
    end

    assert_redirected_to pricing_structure_path(assigns(:pricing_structure))
  end

  test "should show pricing_structure" do
    get :show, id: @pricing_structure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pricing_structure
    assert_response :success
  end

  test "should update pricing_structure" do
    put :update, id: @pricing_structure, pricing_structure: @pricing_structure.attributes
    assert_redirected_to pricing_structure_path(assigns(:pricing_structure))
  end

  test "should destroy pricing_structure" do
    assert_difference('PricingStructure.count', -1) do
      delete :destroy, id: @pricing_structure
    end

    assert_redirected_to pricing_structures_path
  end
end
