require 'test_helper'

class StarGroupsControllerTest < ActionController::TestCase
  setup do
    @star_group = star_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:star_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create star_group" do
    assert_difference('StarGroup.count') do
      post :create, star_group: {  }
    end

    assert_redirected_to star_group_path(assigns(:star_group))
  end

  test "should show star_group" do
    get :show, id: @star_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @star_group
    assert_response :success
  end

  test "should update star_group" do
    patch :update, id: @star_group, star_group: {  }
    assert_redirected_to star_group_path(assigns(:star_group))
  end

  test "should destroy star_group" do
    assert_difference('StarGroup.count', -1) do
      delete :destroy, id: @star_group
    end

    assert_redirected_to star_groups_path
  end
end
