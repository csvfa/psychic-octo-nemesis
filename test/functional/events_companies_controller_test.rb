require 'test_helper'

class EventsCompaniesControllerTest < ActionController::TestCase
  setup do
    @events_company = events_companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events_companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create events_company" do
    assert_difference('EventsCompany.count') do
      post :create, :events_company => @events_company.attributes
    end

    assert_redirected_to events_company_path(assigns(:events_company))
  end

  test "should show events_company" do
    get :show, :id => @events_company
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @events_company
    assert_response :success
  end

  test "should update events_company" do
    put :update, :id => @events_company, :events_company => @events_company.attributes
    assert_redirected_to events_company_path(assigns(:events_company))
  end

  test "should destroy events_company" do
    assert_difference('EventsCompany.count', -1) do
      delete :destroy, :id => @events_company
    end

    assert_redirected_to events_companies_path
  end
end
